// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see. 
 * You can update your password at any time.
 */
contract PasswordStore {
    error PasswordStore__NotOwner();
    error PasswordStore__CannotSetPassword();

    address private s_owner;
    bytes32 private s_password;

    event SetPasswordOwner(address indexed passwordOwner);

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password.
     * @param newPassword The new password to set.
     */
    function setPassword(string memory newPassword) external {
        if (msg.sender != s_owner) revert PasswordStore__CannotSetPassword();
        s_password = keccak256(abi.encodePacked(newPassword));
        emit SetPasswordOwner(msg.sender);
    }

    /*
     * @notice This allows only the owner to retrieve the password.
     * @param newPassword The new password to set.
     * The getPassword Function returns a bool which indicates if the password set is true
     */
    function getPassword(string memory password) external view returns (bool isValid) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return keccak256(abi.encodePacked(password)) == s_password;
    }

    // Getter Functions

    function getEncodedPassword() external view returns(bytes32){
        return s_password;
    }
}
