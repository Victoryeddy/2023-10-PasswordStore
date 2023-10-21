// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console2} from "../lib/forge-std/src/Test.sol";
import {PasswordStore} from "../src/PasswordStore.sol";
import {DeployPasswordStore} from "../script/DeployPasswordStore.s.sol";

contract PasswordStoreTest is Test {
    PasswordStore public passwordStore;
    DeployPasswordStore public deployer;
    address public owner;

    address public nonOwner = makeAddr("nonOwner");

    event SetPasswordOwner(address indexed passwordOwner);

    function setUp() public {
        deployer = new DeployPasswordStore();
        passwordStore = deployer.run();
        owner = msg.sender;
    }

    function testOwnerCanSetPasswordEmitsOwnerAndEncryptsPassword() public {
        // Arrange
        vm.startPrank(owner);
        string memory expectedPassword = "myNewPassword";

        // Act
        vm.expectEmit();
        emit SetPasswordOwner(owner);
        passwordStore.setPassword(expectedPassword);
        
        // console2.log(passwordStore.getEncodedPassword());
        // console2.log(keccak256(abi.encodePacked(expectedPassword)));

        // Assert
        assertEq(passwordStore.getEncodedPassword() , keccak256(abi.encodePacked(expectedPassword)));
    }

    function testOnlyOwnerCanGetPassword() public {
        // Arrange
        vm.startPrank(owner);
        string memory expectedPassword = "myNewPassword";
        passwordStore.setPassword(expectedPassword);
        vm.stopPrank();

        vm.startPrank(nonOwner);    
        // Act

        vm.expectRevert(PasswordStore.PasswordStore__NotOwner.selector);
        (bool isValid) = passwordStore.getPassword("A new Day");

        // Assert
        assert(isValid == false);
    }
}
