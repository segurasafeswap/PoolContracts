# Update the Smart Contract with the IPFS CID by calling setIPFSCID to store CID

from web3 import Web3
from web3.middleware import geth_poa_middleware

# Ethereum node provider URL and Contract Details
provider_url = 'https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY' # Replace with your Ethereum node provider
contract_address = 'YOUR_CONTRACT_ADDRESS'  # Replace with your contract address
contract_abi = '''Your Contract ABI'''      # Replace with your contract ABI

# Connect to Ethereum node
w3 = Web3(Web3.HTTPProvider(provider_url))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)  # Required only for PoA networks like Binance Smart Chain

# Ensure connection to node
if not w3.isConnected():
    raise Exception("Unable to connect to Ethereum node")

# Setup the contract
contract = w3.eth.contract(address=contract_address, abi=contract_abi)

# Sender Account Details
sender_address = 'YOUR_ACCOUNT_ADDRESS'  # Replace with your account address
private_key = 'YOUR_PRIVATE_KEY'        # Replace with your account private key

# Function to set the IPFS CID
def set_ipfs_cid(id, cid):
    nonce = w3.eth.getTransactionCount(sender_address)
    transaction = contract.functions.setIPFSCID(id, cid).buildTransaction({
        'chainId': 1,  # Replace with the correct chain ID
        'gas': 2000000,
        'gasPrice': w3.toWei('50', 'gwei'),
        'nonce': nonce
    })

    # Sign the transaction
    signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

    # Send the transaction
    tx_hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print(f"Transaction hash: {tx_hash.hex()}")

    # Wait for the transaction to be mined
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    print(f"Transaction receipt: {tx_receipt}")

# Example Usage
id = 1  # Replace with your identifier
cid = 'QmYourCID'  # Replace with your IPFS CID
set_ipfs_cid(id, cid)