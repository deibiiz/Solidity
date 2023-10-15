from brownie import accounts, config, SimpleStorage, network

def deploy_simple_storage():
    account = get_account()
    Simple_storage = SimpleStorage.deploy({"from": account})
    stored_value = Simple_storage.retrieve()
    print(stored_value)
    transaction = Simple_storage.store(42, {"from": account})
    transaction.wait(1) #espere que se complete la transaccion para seguir ejecutando codigo
    updated_stored_value = Simple_storage.retrieve()
    print(updated_stored_value)

def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"]) #esta forma es rapida solo para cuentas ficticias. -> "brownie accounts new [nombre]".


def main():
    deploy_simple_storage()

