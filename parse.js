var rl = require('readlines');
var web3 = require('web3');
var cleanAddr = [];
var CoinFi = artifacts.require("./CoinFi.sol");


// console.log(CoinFi)
// var lines = rl.readlinesSync('./whitelist.csv');
//  for(var i in lines){
//    if (web3.utils.isAddress(lines[i])) {
//      cleanAddr.push(lines[i]);
//    }
//  };
//
// var counter = 0
//
// console.log(cleanAddr)
