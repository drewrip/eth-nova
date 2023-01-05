const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BN } = require('@openzeppelin/test-helpers');
const { poseidonContract: poseidonGenContract } = require("circomlibjs");

describe("poseidon", function () {
    let owner;
    let poseidon2Elements, poseidon3Elements, poseidon;
  
    before(async () => {
      [owner] = await ethers.getSigners();
  
      let abi = poseidonGenContract.generateABI(2);
      let code = poseidonGenContract.createCode(2);
      const Poseidon2Elements = new ethers.ContractFactory(abi, code, owner);
      poseidon2Elements = await Poseidon2Elements.deploy();
      await poseidon2Elements.deployed();

      abi = poseidonGenContract.generateABI(3);
      code = poseidonGenContract.createCode(3);
      const Poseidon3Elements = new ethers.ContractFactory(abi, code, owner);
      poseidon3Elements = await Poseidon3Elements.deploy();
      await poseidon3Elements.deployed();
  
      const Poseidon = await ethers.getContractFactory("Poseidon");
      poseidon = await Poseidon.deploy(
        poseidon2Elements.address,
        poseidon3Elements.address
      );
      await poseidon.deployed();

      const Verifier = await ethers.getContractFactory("Verifier");
      verifier = await Verifier.deploy(poseidon.address);
      await poseidon.deployed();
    });
  
    it("check poseidon hash function with inputs [1, 2]", async () => {
      // poseidon goiden3 [extracted using go-iden3-crypto/poseidon implementation]
      const resGo =
        "7853200120776062878684798364095072458815029376092732009249414926327459813530";
      // poseidon smartcontract
      const resSC = await verifier.hash2([1, 2]);
      expect(resSC).to.be.equal(resGo);
    });

    it("sponge absorb 1", async () => {
      // poseidon goiden3 [extracted using go-iden3-crypto/poseidon implementation]
      const res =
        "313014010695700683646576007391559457569";
      // poseidon smartcontract
      const resSC = await verifier.spongeAbsorbSqueeze(
        ["10852932116835785472066100842795129626838246619700435391496453456864446256266"]
      );

      expect(resSC).to.be.equal(res);
    });
  
});