var DEXONBet = artifacts.require("./DEXONBet.sol");

module.exports = function(deployer) {
  deployer.deploy(DEXONBet, 98);
};
