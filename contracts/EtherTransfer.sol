// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

contract EtherTransfer {
    error EtherTransfer_NoEtherSent();
    error EtherTransfer__InvalidRecipient();
    error EtherTransfer__TransferFailed();

    // Event emitted when Ether is transferred
    event EtherTransferred(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    // Transfer Ether to a recipient address
    function transferEther(address payable _recipient) public payable {
        if (msg.value <= 0) revert EtherTransfer_NoEtherSent();
        if (_recipient == address(0)) revert EtherTransfer__InvalidRecipient();

        (bool success, ) = _recipient.call{value: msg.value}("");
        if (success) revert EtherTransfer__TransferFailed();

        emit EtherTransferred(msg.sender, _recipient, msg.value);
    }

    // Fallback function to receive Ether directly
    receive() external payable {}
}
