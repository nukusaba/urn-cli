#!/usr/bin/fish

# cli settings utility for urn-gtk written by nukusaba

# set base vars
set -g checked "✔"
set -g disabled " "
set -g gset_get "gsettings get wildmouse.urn"
set -g gset_set "gsettings set wildmouse.urn"
set -g theme_dir "/usr/local/share/urn/themes/"

# get settings
function get_settings
    set -g hotkey_setting (eval $gset_get global-hotkeys)
    set -g hide_cursor_setting (eval $gset_get hide-cursor)
    set -g win_decor_setting (eval $gset_get start-decorated)
    set -g on_top_setting (eval $gset_get start-on-top)
    set -g theme_setting (eval $gset_get theme)

    switch $hotkey_setting
        case false
            set -g hotkey_setting $disabled
        case true
            set -g hotkey_setting $checked
        case "*"
            set -g hotkey_setting "ERROR"
    end

    switch $hide_cursor_setting
        case false
            set -g hide_cursor_setting $disabled
        case true
            set -g hide_cursor_setting $checked
        case "*"
            set -g hide_cursor_setting "ERROR"
    end

    switch $win_decor_setting
        case false
            set -g win_decor_setting $disabled
        case true
            set -g win_decor_setting $checked
        case "*"
            set -g win_decor_setting "ERROR"
    end

    switch $on_top_setting
        case false
            set -g on_top_setting $disabled
        case true
            set -g on_top_setting $checked
        case "*"
            set -g on_top_setting "ERROR"
    end
end

function menu_setting_manager
    switch $setting_option
        case "global-hotkeys"
            set -g setting_var $hotkey_setting
        case "hide-cursor"
            set -g setting_var $hide_cursor_setting
        case "start-decorated"
            set -g setting_var $win_decor_setting
        case "start-on-top"
            set -g setting_var $on_top_setting
    end

    if [ "$setting_var" = "$checked" ]
        eval $gset_set $setting_option false
        main_menu
    else if [ "$setting_var" = "$disabled" ]
        eval $gset_set $setting_option true
        main_menu
    else
        echo "ERROR"
        return
    end
end

# main menu
function main_menu
    get_settings
    clear
    set -g pad_length 27
    set -g theme_setting (pad_string $theme_setting)
    echo "
    ┌─── urn-cli - Menu ─────────────────────┐
    │                                        │
    │  1. Global Hotkeys "(set_color brgreen)"$hotkey_setting"(set_color normal)"                   │
    │  2. Hide Cursor "(set_color brgreen)"$hide_cursor_setting"(set_color normal)"                      │
    │  3. Window Decoration on Start "(set_color brgreen)"$win_decor_setting"(set_color normal)"       │
    │  4. Force Always On Top at Start "(set_color brgreen)"$on_top_setting"(set_color normal)"     │
    │                                        │
    │  5. Keybinds                           │
    │  6. Theme "(set_color brgreen)"$theme_setting"(set_color normal)"  │
    │  "(set_color brred)"7. Delete Theme"(set_color normal)"                       │
    │                                        │
    │  "(set_color brblack)"NOTE:"(set_color normal)" You can install a new theme     │
    │        with "(set_color brred)"'urn-cli -i [path]'"(set_color normal)"        │
    │     "(set_color brred)"Red"(set_color normal)" text means requires sudo       │
    │                                        │
    │"(set_color brblue)"  Q. Quit "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "    Select option: " -n1 selected_option
    switch $selected_option
        case "1" # hotkeys
            set -g setting_option "global-hotkeys"
            menu_setting_manager
        case "2" # hide cursor
            set -g setting_option "hide-cursor"
            menu_setting_manager
        case "3" # enable window decoration
            set -g setting_option "start-decorated"
            menu_setting_manager
        case "4" # always ontop
            set -g setting_option "start-on-top"
            menu_setting_manager
        case "Q" "q"
            echo "    Quiting..."
            echo ""
            exit

        # non-direct settings options
        case "5"
            keybind_menu
        case "6"
            theme_menu
        case "7"
            theme_rm_menu
    end
end

# get keybinds
function get_keybinds
    set -g start_split_key (eval $gset_get keybind-start-split)
    set -g stop_reset_key (eval $gset_get keybind-stop-reset)
    set -g cancel_key (eval $gset_get keybind-cancel)
    set -g unsplit_key (eval $gset_get keybind-unsplit)
    set -g skip_key (eval $gset_get keybind-skip-split)
    set -g toggle_decoration_key (eval $gset_get keybind-toggle-decorations)

    set -g pad_length 15
    set -g start_split_key (pad_string $start_split_key)
    set -g stop_reset_key (pad_string $stop_reset_key)
    set -g cancel_key (pad_string $cancel_key)
    set -g unsplit_key (pad_string $unsplit_key)
    set -g skip_key (pad_string $skip_key)
    set -g toggle_decoration_key (pad_string $toggle_decoration_key)
end

# keybind type selecor
function keybind_type_selector
    clear
    echo "
    ┌─── urn-cli - Keybind Type ─────────────┐
    │                                        │
    │  1. Regular Key                        │
    │  2. Special Key                        │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │  Special keys include: Delete,         │
    │                        Arrow Keys,     │
    │                        Page Up/Down,   │
    │                        ETC...          │
    │                                        │
    │                                        │
    │"(set_color brblue)"  B. Back "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "    Select option: " -n1 selected_option
    switch $selected_option
        case "1"
            regular_key_chooser
        case "2"
            special_key_chooser
        case "q" "Q" "b" "B"
            keybind_menu
    end
end

# regular key chooser
function regular_key_chooser
    clear
    echo "
    ┌─── urn-cli - Press Key ────────────────┐
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │            "(set_color brpurple)"Press a Key..."(set_color normal)"              │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │"(set_color brblue)"  B. Back "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "     Press a Key: " -n1 -g choosen_key
    key_set_fn
end

# special key chooser
function special_key_chooser
    clear
    echo "
    ┌─── urn-cli - Select Keybind ───────────┐
    │                                        │
    │  0. Backspace                          │
    │  1. Page Up                            │
    │  2. Page Down                          │
    │  3. Delete                             │
    │  4. Arrow Up                           │
    │  5. Arrow Down                         │
    │  6. Arrow Left                         │
    │  7. Arrow Right                        │
    │  8. Space                              │
    │  9. Insert                             │
    │                                        │
    │                                        │
    │"(set_color brblue)"  B. Back "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "     Select Key: " -n1 selected_option
    switch $selected_option
        case "0"
            set -g choosen_key "BackSpace"
        case "1"
            set -g choosen_key "Page_Up"
        case "2"
            set -g choosen_key "Page_Down"
        case "3"
            set -g choosen_key "Delete"
        case "4"
            set -g choosen_key "Up"
        case "5"
            set -g choosen_key "Down"
        case "6"
            set -g choosen_key "Left"
        case "7"
            set -g choosen_key "Right"
        case "8"
            set -g choosen_key "space"
        case "9"
            set -g choosen_key "Insert"
    end
    key_set_fn
end

function key_set_fn
    eval "$gset_set $keybind '$choosen_key'"
    keybind_menu
end

# keybind menu
function keybind_menu
    get_keybinds
    clear
    echo "
    ┌─── urn-cli - Keybinds ─────────────────┐
    │                                        │
    │  1. Start/Split "(set_color bryellow)"$start_split_key"(set_color normal)"        │
    │  2. Stop/Reset "(set_color bryellow)"$stop_reset_key"(set_color normal)"         │
    │  3. Cancel "(set_color bryellow)"$cancel_key"(set_color normal)"             │
    │  4. Undo Split "(set_color bryellow)"$unsplit_key"(set_color normal)"         │
    │  5. Skip Split "(set_color bryellow)"$skip_key"(set_color normal)"         │
    │                                        │
    │  6. Toggle Decoration "(set_color bryellow)"$toggle_decoration_key"(set_color normal)"  │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │                                        │
    │"(set_color brblue)"  B. Back "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "    Select option: " -n1 selected_option
    switch $selected_option
        case "1"
            set -g keybind "keybind-start-split"
        case "2"
            set -g keybind "keybind-stop-reset"
        case "3"
            set -g keybind "keybind-cancel"
        case "4"
            set -g keybind "keybind-unsplit"
        case "5"
            set -g keybind "keybind-skip-split"
        case "6"
            set -g keybind "keybind-toggle-decorations"
        case "b" "B" "q" "Q"
            main_menu
    end
    keybind_type_selector
end

#theme menu
function theme_menu
    set -g theme_list (ls $theme_dir)
    set -g list_count (count $theme_list)


    clear
    echo "
    ┌─── urn-cli - Select Theme ─────────────┐
    │                                        │"
    for i in (seq $list_count)
        set -g theme_number (printf "%02d" $i)
        set -g pad_length 31
        set -g theme_string (pad_string $theme_list[$i])
        echo "    │  $theme_number. $theme_string   │"
        set -g theme_setting_name$i $theme_list[$i]
    end
    echo "    │                                        │
    │"(set_color brblue)"  B. Back "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "     Select Theme: " selected_theme
    switch $selected_theme
        case "b" "B" "q" "Q"
            main_menu
        case "*"
            eval $gset_set theme \$theme_setting_name$selected_theme
            main_menu
    end
end

#theme delete menu
function theme_rm_menu
    set -g theme_list (ls $theme_dir)
    set -g list_count (count $theme_list)


    clear
    echo "
    ┌─── urn-cli - Select Theme to Delete ───┐
    │                                        │"
    for i in (seq $list_count)
        set -g theme_number (printf "%02d" $i)
        set -g pad_length 31
        set -g theme_string (pad_string $theme_list[$i])
        echo "    │  "(set_color brred)"$theme_number. $theme_string"(set_color normal)"   │"
        set -g theme_setting_name$i $theme_list[$i]
    end
    echo "    │                                        │
    │"(set_color brblue)"  B. Back "(set_color normal)"                              │
    └────────────────────────────────────────┘"
    read -P "     Select Theme: " selected_theme
    switch $selected_theme
        case "b" "B" "q" "Q"
            set_color normal
            main_menu
        case "*"
            sudo -k
            set_color brred
            eval "sudo rm -r \$theme_dir\$theme_setting_name$selected_theme"
            set_color normal
            main_menu
    end
end

function pad_string
    set len (string length -- $argv[1])
    set spaces (math $pad_length - $len)
    echo "$argv[1]"(string repeat -n $spaces " ")
end

# start function
function urn-cli
    switch $argv[1]
        case ""
            main_menu
        case "-i" "--install"
            set_color brred
            echo "   **WARNING**    "
            set_color normal

            read -P "Sudo Access is Rquired to install a theme. Continue? [Y/n]" -n1 sudoconfirm
                switch $sudoconfirm
                    case "y" "Y" ""
                    case "n" "N"
                        echo "  Exiting..."
                        exit
                    case "*"
                        set_color brred
                        echo "  **ERROR** "
                        set_color normal
                        echo "  Not a valid setting. Exiting..."
                        exit
                end

                if test -d $argv[2]
                    set_color brgreen
                    echo "  **VALID** "
                    set_color normal
                else
                    set_color brred
                    echo "  **ERROR** "
                    set_color normal
                    echo "  Not a directory"
                    exit
                end

                set_color brred
                sudo cp $argv[2] $theme_dir
                set_color normal
                echo "  Done."
                exit

        case "*"
            set_color brred
            echo "  **ERROR**"
            set_color normal
            echo "  Invalid Argument"
    end
end

# ________ Start Script ________
urn-cli
