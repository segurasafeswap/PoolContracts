from web3 import Web3
import ipfshttpclient

client = ipfshttpclient.connect('/ip4/127.0.0.1/tcp/5001/http')

def upload_to_ipfs(file_path):
    res = client.add(file_path)
    return res['Hash'] # The CID of the uploaded file

def download_from_ipfs(cid):
    file_data = client.cat(cid)
    return file_data  # Return the data to be sent to the user or saved to disk


# Ethereum connection setup
provider_url = 'https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY' # Replace with your Ethereum node provider
w3 = Web3(Web3.HTTPProvider(provider_url))

# Smart Contract ABI and Address
contract_address = 'YOUR_CONTRACT_ADDRESS'  # Replace with your contract address
contract_abi = '''Your Contract ABI'''      # Replace with your contract ABI
contract = w3.eth.contract(address=contract_address, abi=contract_abi)

# Account details
sender_address = 'YOUR_ACCOUNT_ADDRESS'  # Replace with your account address
private_key = 'YOUR_PRIVATE_KEY'        # Replace with your account private key

# Connect to IPFS
ipfs_client = ipfshttpclient.connect('/ip4/127.0.0.1/tcp/5001/http')

def upload_to_ipfs(file_path):
    result = ipfs_client.add(file_path)
    cid = result['Hash']
    return cid

def save_new_item(file_path, item_id):
    # Upload file to IPFS and get the CID
    cid = upload_to_ipfs(file_path)

    # Prepare the transaction
    nonce = w3.eth.getTransactionCount(sender_address)
    transaction = contract.functions.setIPFSCID(item_id, cid).buildTransaction({
        'chainId': 1,  # Replace with the correct chain ID for your network
        'gas': 2000000,
        'gasPrice': w3.toWei('50', 'gwei'),
        'nonce': nonce
    })

    # Sign the transaction
    signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

    # Send the transaction
    tx_hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    return tx_receipt.transactionHash

# Example Usage
file_path = 'path/to/your/file' # Path to the file you want to upload to IPFS
item_id = 1  # Unique identifier for the new item
transaction_hash = save_new_item(file_path, item_id)
print(f"Transaction Hash: {transaction_hash}")