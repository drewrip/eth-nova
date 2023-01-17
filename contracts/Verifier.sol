pragma solidity ^0.8.17;
import {SumCheck} from "./SumCheck.sol";
import {RO} from "./RO.sol";
import "hardhat/console.sol";

contract Verifier {

    struct RecursiveSNARK {
        uint256 num_steps;
        uint256[] z0_primary;
        uint256[] z0_secondary;
        uint256[] zi_primary;
        uint256[] zi_secondary;
        uint256 r1cs_shape_primary_digest;
        uint256 r1cs_shape_secondary_digest;
        uint256 r_U_primary_comm_W;
        uint256 r_U_primary_comm_E;
        uint256 r_U_primary_u;
        uint256 r_U_secondary_comm_W;
        uint256 r_U_secondary_comm_E;
        uint256 r_U_secondary_u;
        uint256[] r_U_primary_X;
        uint256[] r_U_secondary_X;
        uint256[] l_U_primary_X;
        uint256[] l_U_secondary_X;
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

    function challenge(uint256[] memory transcript) public pure returns (uint256) {
        return RO.spongeAbsorbSqueeze(transcript);
    }

    // Using a number of limbs of 4 as a constant
    function scalar_to_limbs(uint256 bn) public pure returns (uint256[4] memory) {
        // Mask that contains limb_width number of 1's
        uint256 mask = 0xFFFFFFFFFFFFFFFF;
        uint256[4] memory limbs;
        limbs[0] = bn & mask;
        bn >>= 64;
        limbs[1] = bn & mask;
        bn >>= 64;
        limbs[2] = bn & mask;
        bn >>= 64;
        limbs[3] = bn & mask;
        return limbs;
    }

    // This is incomplete, implementing one part of the verification
    // process at a time
    function recursive_verify(
        RecursiveSNARK memory proof
    ) public returns (bool) {
        // check if the output hashes in R1CS instances point to the right running instances
        uint256[] memory hasher = new uint256[](proof.z0_primary.length + 17);
        uint hasher_pos = 0;

        hasher[hasher_pos] = proof.r1cs_shape_secondary_digest;
        hasher_pos += 1;
        hasher[hasher_pos] = proof.num_steps;
        hasher_pos += 1;

        for(uint i = 0; i < proof.z0_primary.length; i++){
            hasher[hasher_pos] = proof.z0_primary[i];
            hasher_pos += 1;
        }
        for(uint i = 0; i < proof.zi_primary.length; i++){
            hasher[hasher_pos] = proof.zi_primary[i];
            hasher_pos += 1;
        }


        // FIX: the commitments need to get absorbed as coordinates!
        hasher[hasher_pos] = proof.r_U_secondary_comm_W;
        hasher_pos += 1;
        hasher[hasher_pos] = proof.r_U_secondary_comm_W;
        hasher_pos += 1;
        hasher[hasher_pos] = proof.r_U_secondary_u;
        hasher_pos += 1;

        for(uint i = 0; i < proof.r_U_secondary_X.length; i++){
            uint256[4] memory x = scalar_to_limbs(proof.r_U_secondary_X[i]);
            for(uint j = 0; j < 4; j++){
                hasher[hasher_pos] = x[j];
                hasher_pos += 1;
            }
        }

        uint256[] memory hasher2 = new uint256[](proof.z0_primary.length + 17);
        uint hasher_pos2 = 0;

        hasher2[hasher_pos2] = proof.r1cs_shape_primary_digest;
        hasher_pos2 += 1;
        hasher2[hasher_pos2] = proof.num_steps;
        hasher_pos2 += 1;

        for(uint i = 0; i < proof.z0_secondary.length; i++){
            hasher2[hasher_pos2] = proof.z0_secondary[i];
            hasher_pos2 += 1;
        }
        for(uint i = 0; i < proof.zi_secondary.length; i++){
            hasher2[hasher_pos2] = proof.zi_secondary[i];
            hasher_pos2 += 1;
        }

        hasher2[hasher_pos2] = proof.r_U_primary_comm_W;
        hasher_pos2 += 1;
        hasher2[hasher_pos2] = proof.r_U_primary_comm_W;
        hasher_pos2 += 1;
        hasher2[hasher_pos2] = proof.r_U_primary_u;
        hasher_pos2 += 1;

        for(uint i = 0; i < proof.r_U_primary_X.length; i++){
            uint256[4] memory x = scalar_to_limbs(proof.r_U_primary_X[i]);
            for(uint j = 0; j < 4; j++){
                hasher2[hasher_pos2] = x[j];
                hasher_pos2 += 1;
            }
        }

        uint256 hash_primary = RO.spongeAbsorbSqueeze(hasher);
        uint256 hash_secondary = RO.spongeAbsorbSqueeze(hasher2);

        if(hash_primary != proof.l_U_primary_X[1] || hash_secondary != proof.l_U_secondary_X[1]){
            return false;
        }

        // Check for satisfiability
        // ...

        return true;
    }

    function compressed_verify() public returns (bool) {
        return false;
    }
}