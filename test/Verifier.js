const { expect } = require("chai");
const { poseidonContract: poseidonGenContract } = require("circomlibjs");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

async function deployVerifier() {
  let owner;
  let poseidon2Elements, poseidon3Elements, poseidon;

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
  const verifier = await Verifier.deploy(poseidon.address);
  await verifier.deployed();
  return verifier;
}

describe("Evaluate at Zero", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("x^2 + x + 1", async function () {
    expect(await verifier.test_eval_at_zero([1, 1, 1])).to.equal(1);
  });
  it("3x^2 + 2x + 5", async function () {
    expect(await verifier.test_eval_at_zero([5, 2, 3])).to.equal(5);
  });
});

describe("Evaluate at One", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("x^2 + x + 1", async function () {
    expect(await verifier.test_eval_at_one([1, 1, 1])).to.equal(3);
  });
  it("3x^2 + 2x + 5", async function () {
    expect(await verifier.test_eval_at_one([5, 2, 3])).to.equal(10);
  });
});

describe("Evaluate at X", function () {

  let verifier;

  before(async () => {
    verifier = await loadFixture(deployVerifier);
  });

  it("x^2 + x + 1, @ x=1", async function () {
    expect(await verifier.test_eval_at_x([1, 1, 1], 1)).to.equal(3);
  });
  it("3x^2 + 2x + 5, @ x=3", async function () {
    expect(await verifier.test_eval_at_x([5, 2, 3], 3)).to.equal(38);
  });
});