# Get the Smart Contract with the IPFS CID by calling setIPFSCID to store CID

from web3 import Web3

# Connect to Ethereum node
w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_API_KEY'))  # Replace with your Ethereum node provider

# Smart Contract ABI and Address
contract_abi = '''Your Contract ABI'''
contract_address = 'YOUR_CONTRACT_ADDRESS'

contract = w3.eth.contract(address=contract_address, abi=contract_abi)

def get_ipfs_hash(_id):
    try:
        cid = contract.functions.getIPFSCID(_id).call()
        print('CID:', cid)
        return cid
    except Exception as e:
        print('Error fetching CID:', e)

# Example Usage
_id = 1  # Replace with your identifier
cid = get_ipfs_hash(_id)
url = f'https://ipfs.io/ipfs/{cid}'
print('Access URL:', url)
# Use this URL to access the data on IPFS