from math import exp
from brownie import SimpleStorage, accounts

def test_deploy():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    expected = 0

    assert starting_value == expected

def test_updating_storage():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    txn = simple_storage.store(42, {"from": account})
    txn.wait(1)
    expected = 42

    assert simple_storage.retrieve() == expected
