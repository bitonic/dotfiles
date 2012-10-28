undefine_key(default_base_keymap, "C-x C-f");
define_key(default_base_keymap, "C-o", "find-url-new-buffer");
undefine_key(default_base_keymap, "C-x b");
define_key(default_base_keymap, "C-,", "switch-to-buffer");

url_completion_use_history = true;

mode_line_mode(false);

require("session.js");
session_auto_save_load = true;

require("cookie.js");
add_hook("quit_hook", clear_cookies, true, false);

// Some websites don't like conkeror.
set_user_agent(
    "Mozilla/5.0 (X11; Linux x86_64; rv:8.0.1) Gecko/20100101 Firefox/8.0.1");

require("duckduckgo");

url_remoting_fn = load_url_in_new_buffer;

session_pref("font.minimum-size.x-western", 13);
session_pref("font.minimum-size.x-unicode", 13);
