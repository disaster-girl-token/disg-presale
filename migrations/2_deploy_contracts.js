const Token = artifacts.require("Disastergirltoken");
const Presale = artifacts.require("Presale");
const BN = require("bn.js");

function tokens(n){
    return web3.utils.toWei(n,'Gwei');
}

module.exports = async function(deployer){

    // Deployed Token  
    const token = await Token.deployed()
    
    // Deploy Presale
    await deployer.deploy(Presale, token.address);
    const presale = await Presale.deployed();
  

  // Transfer all tokens to Presale (10 billion)
  await token.transfer(presale.address, tokens(10*10**9/0.88/0.88+""))

}


