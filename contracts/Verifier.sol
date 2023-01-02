pragma solidity ^0.8.17;
import {SumCheck} from "./SumCheck.sol";
import {Poseidon} from "./Poseidon.sol";

contract Verifier {
    Poseidon _poseidon;

    constructor(address _poseidonContractAddr){
        _poseidon = Poseidon(_poseidonContractAddr);
    }

    function hash2(uint256[2] memory inp) public view returns (uint256){
        return _poseidon.hash2(inp);
    }

    function test_eval_at_zero(uint[] memory g) public pure returns (uint) {
        return SumCheck.eval_at_zero(g);
    }

    function test_eval_at_one(uint[] memory g) public pure returns (uint) {
        return SumCheck.eval_at_one(g);
    }

    function test_eval_at_x(uint[] memory g, uint x) public pure returns (uint) {
        return SumCheck.eval_at_x(g, x);
    }
}

