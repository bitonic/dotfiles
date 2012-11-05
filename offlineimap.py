import gnomekeyring as gk, glib

keyring_name = 'login'

def get_password(name):
    item_keys = gk.list_item_ids_sync(keyring_name)
    for key in item_keys:
        item_info = gk.item_get_info_sync(keyring_name, key)
        if item_info.get_display_name() == name:
            return item_info.get_secret()

