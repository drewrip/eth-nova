const { expect } = require("chai");
const hre = require("hardhat");

describe("Evaluate at Zero", function () {
  it("x^2 + x + 1", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.test_eval_at_zero([1, 1, 1])).to.equal(1);
  });
  it("3x^2 + 2x + 5", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.test_eval_at_zero([5, 2, 3])).to.equal(5);
  });
});

describe("Evaluate at One", function () {
  it("x^2 + x + 1", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.test_eval_at_one([1, 1, 1])).to.equal(3);
  });
  it("3x^2 + 2x + 5", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.test_eval_at_one([5, 2, 3])).to.equal(10);
  });
});

describe("Evaluate at X", function () {
  it("x^2 + x + 1, @ x=1", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.test_eval_at_x([1, 1, 1], 1)).to.equal(3);
  });
  it("3x^2 + 2x + 5, @ x=3", async function () {
    const Verifier = await hre.ethers.getContractFactory("Verifier");
    const verifier = await Verifier.deploy();
    expect(await verifier.test_eval_at_x([5, 2, 3], 3)).to.equal(38);
  });
});