pragma solidity ^0.8.17;

library SumCheck {

    // Primes that define the base fields of the pasta_curves
    // For more details see: https://electriccoin.co/blog/the-pasta-curves-for-halo-2-and-beyond/
    
    // The base field of the Pallas curve is GF(P)
    uint public constant P = 28948022309329048855892746252171976963363056481941560715954676764349967630337;
    // The base field of the Vesta curve is GF(Q)
    uint public constant Q = 28948022309329048855892746252171976963363056481941647379679742748393362948097;

    function mult(uint a, uint b) internal pure returns (uint) {
        return a * b;
    }

    // NOTE: this method is currently incomplete. Even if it correctly verifies
    //  the sum, it might not be useful for Nova. Slight differences in
    //  implementation, for instance, how the inputs to the hash functions are padded,
    //  might result in the rejection of a valid proof.
    //
    // Performs the sumcheck protocol
    // upolys - coefficients of the univariate polynomials, a flat representation of mu
    //  different polynomials
    // l - number of terms
    // mu - number of rounds
    // T - final value of the summation
    function sumcheck(uint256[] calldata upolys, uint256 l, uint256 mu, uint256 T) internal pure returns (bool) {
        uint256 e = T;
        uint256 r = uint256(sha256("transcript"));
        for(uint i = 0; i < mu; i++){
            uint256[] memory g = upolys[i*l:(i+1)*l];
            r = uint256(sha256(abi.encode(r, g)));
            if(eval_at_zero(g) + eval_at_one(g) != e) {
                return false;
            }
            e = eval_at_x(g, r);
        }
        return true;
    }

    // Evaluates univariate polynomial g at 1
    function eval_at_one(uint[] memory g) internal pure returns (uint) {
        uint total = 0;
        for(uint i = 0; i < g.length; i++){
            total = addmod(total, g[i], P);
        }
        return total;
    }

    // Evaluates univariate polynomial g at 0
    // Also assumes that the poly has at least 1 term
    function eval_at_zero(uint[] memory g) internal pure returns (uint) {
        return g[0];
    }

    function eval_at_x(uint[] memory g, uint x) internal pure returns (uint) {
        uint[] memory powers = new uint[](g.length);
        uint total = 0;
        powers[0] = 1;

        // First compute what x^i will be for each term
        for(uint i = 1; i < g.length; i++){
            powers[i] = mulmod(powers[i-1], x, P);
        }
        // Multiply the computed x^i by the coefficient from g
        for(uint i = 0; i < g.length; i++){
            total = addmod(total, mulmod(powers[i], g[i], P), P);
        }

        return total;
    }
}