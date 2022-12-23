const { expect } = require("chai");
const hre = require("hardhat");

describe("Multiplication", function () {
  it("test multiplication", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.testMult(3, 4)).to.equal(12);
  });
});