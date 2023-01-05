pragma solidity ^0.8.17;
import {SumCheck} from "./SumCheck.sol";
import {RO} from "./RO.sol";

contract Verifier {

    function test_eval_at_zero(uint[] memory g) public pure returns (uint) {
        return SumCheck.eval_at_zero(g);
    }

    function test_eval_at_one(uint[] memory g) public pure returns (uint) {
        return SumCheck.eval_at_one(g);
    }

    function test_eval_at_x(uint[] memory g, uint x) public pure returns (uint) {
        return SumCheck.eval_at_x(g, x);
    }

    function challenge(uint256[] memory transcript) public pure returns (uint256) {
        return RO.spongeAbsorbSqueeze(transcript);
    }
}

