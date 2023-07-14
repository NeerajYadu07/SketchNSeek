const express = require('express');
const http = require('http');
const mongoose = require("mongoose");
const Room = require('./models/room');
const getWord = require('./api/getWord');
const PORT = process.env.PORT || 3000;


const app = express();
const server = http.createServer(app);
const socket = require("socket.io")
var io = socket(server);

// middleware
app.use(express.json());

// mongoDB connection
const DB = "mongodb+srv://neeraj:neeraj123@sketchnseek.cmduq24.mongodb.net/?retryWrites=true&w=majority";
mongoose.connect(DB).then(()=>{
    console.log('database connected!');
}).catch((err)=>{
    console.log(err);
});

io.on('connection',(socket)=>{
    console.log('connected');

    // creating room 
    socket.on('create-room',async({nickName,roomName,occupancy,maxRounds})=>{
        try{
            const existingRoom = await Room.findOne({roomName});
            if(existingRoom){
                socket.emit('invalid-game' , 'Room with this name already exists!');
                return;
            }
            let room = new Room();
            const word = getWord();
            room.word=word;
            room.roomName=roomName;
            room.occupancy=occupancy;
            room.maxRounds=maxRounds;
            
            let player = {
                socketID : socket.id,
                nickName,
                isRoomLeader : true,
            }
            room.players.push(player);
            room = await room.save();
            socket.join(roomName);
            io.to(roomName).emit('update-room',room);
        }
        catch(err){
            console.log(err);
        }
    });
    
    // joining room 
    socket.on('join-room',async({nickName,roomName})=>{
        try{ 
            let room = await Room.findOne({roomName});
            if(!room){
                socket.emit('invalid-game' , 'Room with this name does not exist!');
                return;
            }
            if(room.isJoin){
                let player = {
                    socketID : socket.id,
                    nickName,
                }
                room.players.push(player);
                socket.join(roomName);
                if(room.players.length === room.occupancy){
                    room.isJoin = false;
                }
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(roomName).emit('update-room',room);
            }
            else{
                socket.emit('invalid-game' , 'The game has already started, try again later!');
                return;
            }
        }
        catch(err){
            console.log(err);
        }
    });
    // paint
    socket.on('paint',async({details,roomName})=>{
        io.to(roomName).emit('points',{
            details:details
        });
    });

    // color change
    socket.on('color-change',async({color,roomName})=>{
        io.to(roomName).emit('color-change',color);
    });

    // change stroke width
    socket.on('stroke-width',async({width,roomName})=>{
        io.to(roomName).emit('stroke-width',width);
    });

    // clear screen
    socket.on('clean-screen',async(roomName)=>{
        io.to(roomName).emit('clean-screen','');
    });


    // chat
    socket.on('message',async(data)=>{
        try{
            if(data.message === data.word){
                let room = await Room.find({roomName :data.roomName});
                let userPlayer = room[0].players.filter((player)=>player.nickName === data.username);
                if(data.timeTaken !== 0 ){
                    userPlayer[0].points += Math.round((200/data.timeTaken)*10);
                }
                room = await room[0].save();
                io.to(data.roomName).emit('message',{
                    username : data.username,
                    message : 'Guessed it!',
                    guessedUserCount : data.guessedUserCount + 1,
                })
                socket.emit('close-input',"");
            }
            else{
                io.to(data.roomName).emit('message',{
                    username : data.username,
                    message : data.message,
                    guessedUserCount : data.guessedUserCount,
                });
            }
        }
        catch(err){
            console.log(err);
        }
    });

    // change-turn

    socket.on('change-turn',async(roomName)=>{
        try{
            let room = await Room.findOne({roomName});
            let turnIndex = room.turnIndex;
            if(turnIndex + 1 === room.players.length){
                room.currentRound += 1;
            }
            if(room.currentRound <= room.maxRounds){
                const word = getWord();
                room.word = word;
                room.turnIndex = (turnIndex+1) % room.players.length;
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                io.to(roomName).emit('change-turn',room);
            }
            else{
                // showing the leaderboard
                io.to(roomName).emit('show-leaderboard',room.players)
            }
        }
        catch(err){
            console.log(err);
        }
    });
    // update-score

    socket.on('update-score',async(roomName)=>{
        try{
            let room = await Room.findOne({roomName});
            io.to(roomName).emit('update-score',room);
            
        }
        catch(err){
            console.log(err);
        }
    });

    socket.on('disconnect', async() => {
        try {
            let room = await Room.findOne({"players.socketID": socket.id});
            for(let i=0; i< room.players.length; i++) {
                if(room.players[i].socketID === socket.id) {
                    room.players.splice(i, 1);
                    break;
                }
            }
            room = await room.save();
            if(room.players.length === 1) {
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            } else {
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
        } catch(err) {
            console.log(err);
        }
    });


});

server.listen(PORT,"0.0.0.0",()=>{
    console.log(`connected at port ${PORT}`)
});