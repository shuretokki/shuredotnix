# https://home-manager-options.extranix.com/?query=programs.vscode
# TODO: consider adding zed (https://zed.dev/)

{ lib, pkgs, config, prefs, ... }:
let
  fonts = config.stylix.fonts;
  colors = config.lib.stylix.colors;
in
{
  programs.vscode = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.vscode-fhs;

    # https://home-manager-options.extranix.com/?query=programs.vscode.profiles
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        rust-lang.rust-analyzer
        ms-python.python
        ms-python.vscode-pylance

        github.copilot
        github.copilot-chat
      ];

      # https://home-manager-options.extranix.com/?query=programs.vscode.profiles.%3Cname%3E.userSettings
      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "accessibility.verbosity.terminal" = false;

        "editor.fontFamily" = "'${fonts.monospace.name}'";
        "editor.fontSize" = fonts.sizes.terminal;
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "'${fonts.monospace.name}'";

        "editor.lineNumbers" = "relative";
        "editor.minimap.enabled" = false;
        "editor.cursorBlinking" = "solid";
        "editor.cursorStyle" = "line";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "editor.tabSize" = 2;
        "editor.tabCompletion" = "on";
        "editor.wordWrap" = "off";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = false;
        "editor.language.colorizedBracketPairs" = [];
        "editor.renderLineHighlight" = "none";
        "editor.renderWhitespace" = "none";
        "editor.scrollbar.horizontal" = "hidden";
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollbar.verticalScrollbarSize" = 0;
        "editor.padding.top" = 24;
        "editor.padding.bottom" = 24;
        "editor.lineHeight" = 22;
        "editor.letterSpacing" = 0.9;
        "editor.glyphMargin" = true;
        "editor.stickyScroll.enabled" = false;
        "editor.smoothScrolling" = false;
        "editor.selectionHighlight" = true;
        "editor.occurrencesHighlight" = "off";
        "editor.inlayHints.enabled" = "off";
        "editor.lightbulb.enabled" = "off";
        "editor.hover.delay" = 200;
        "editor.parameterHints.enabled" = true;
        "editor.acceptSuggestionOnEnter" = "smart";
        "editor.suggestSelection" = "first";
        "editor.suggest.preview" = false;
        "editor.quickSuggestions" = { "strings" = "on"; };
        "editor.accessibilitySupport" = "off";
        "editor.fastScrollSensitivity" = 10;
        "editor.mouseWheelScrollSensitivity" = 2;

        "diffEditor.codeLens" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        "diffEditor.maxComputationTime" = 0;
        "diffEditor.renderSideBySide" = false;
        "diffEditor.wordWrap" = "off";

        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.cursorStyleInactive" = "none";
        "terminal.integrated.smoothScrolling" = true;
        "terminal.integrated.stickyScroll.enabled" = true;
        "terminal.integrated.letterSpacing" = 2;
        "terminal.integrated.lineHeight" = 1.4;
        "terminal.integrated.gpuAcceleration" = "off";
        "terminal.integrated.showExitAlert" = false;
        "terminal.integrated.enableImages" = true;
        "terminal.integrated.inheritEnv" = true;
        "terminal.integrated.defaultLocation" = "view";
        "terminal.integrated.hideOnStartup" = "never";
        "terminal.explorerKind" = "external";

        "workbench.activityBar.location" = "hidden";
        "workbench.sideBar.location" = "right";
        "workbench.editor.showTabs" = "none";
        "workbench.startupEditor" = "none";
        "workbench.tips.enabled" = false;
        "workbench.enableExperiments" = false;
        "workbench.layoutControl.enabled" = false;
        "workbench.navigationControl.enabled" = false;
        "workbench.editor.enablePreview" = false;
        "workbench.editor.enablePreviewFromQuickOpen" = false;
        "workbench.editor.enablePreviewFromCodeNavigation" = false;
        "workbench.editor.limit.enabled" = true;
        "workbench.editor.limit.value" = 10;
        "workbench.editor.limit.perEditorGroup" = true;
        "workbench.editor.closeOnFileDelete" = true;
        "workbench.editor.focusRecentEditorAfterClose" = true;
        "workbench.editor.openPositioning" = "first";
        "workbench.editor.restoreViewState" = false;
        "workbench.editor.revealIfOpen" = true;
        "workbench.editor.tabSizing" = "shrink";
        "workbench.editor.wrapTabs" = false;
        "workbench.editor.centeredLayoutAutoResize" = false;
        "workbench.editor.centeredLayoutFixedWidth" = false;
        "workbench.editor.decorations.badges" = false;
        "workbench.editor.decorations.colors" = false;
        "workbench.editor.editorActionsLocation" = "hidden";
        "workbench.editor.highlightModifiedTabs" = false;
        "workbench.editor.splitInGroupLayout" = "horizontal";
        "workbench.editor.untitled.labelFormat" = "name";
        "workbench.reduceMotion" = "off";
        "workbench.settings.enableNaturalLanguageSearch" = false;
        "workbench.welcomePage.walkthroughs.openOnInstall" = false;

        "files.autoSave" = "afterDelay";
        "files.trimTrailingWhitespace" = true;
        "files.hotExit" = "off";
        "files.restoreUndoStack" = false;
        "files.defaultLanguage" = "";
        "files.exclude" = {
          "**/.git" = true;
          "**/.cmake" = true;
          "**/CMakeFiles" = true;
          "**/node_modules" = true;
          "**/build" = true;
        };
        "files.watcherExclude" = {
          "**/.git/**" = true;
          "**/.vscode/**" = true;
          "**/.cmake/**" = true;
          "**/CMakeFiles/**" = true;
          "**/node_modules/**" = true;
          "**/build/**" = true;
          "**/dist/**" = true;
          "**/out/**" = true;
        };

        "window.titleBarStyle" = "native";
        "window.customTitleBarVisibility" = "never";
        "window.menuStyle" = "custom";
        "window.title" = "\${activeEditorShort}";
        "window.restoreWindows" = "none";
        "window.restoreFullscreen" = false;
        "window.zoomLevel" = 0.5;
        "window.newWindowDimensions" = "inherit";
        "window.openFilesInNewWindow" = "off";
        "window.openFoldersInNewWindow" = "off";
        "window.confirmSaveUntitledWorkspace" = false;

        "explorer.compactFolders" = false;
        "explorer.confirmDelete" = false;
        "explorer.expandSingleFolderWorkspaces" = false;
        "explorer.decorations.badges" = false;
        "explorer.incrementalNaming" = "smart";
        "explorer.fileNesting.patterns" = {
          "*.ts" = "\${capture}.js";
          "*.tsx" = "\${capture}.ts";
          "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
          "*.jsx" = "\${capture}.js";
          "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb, bun.lock";
          "tsconfig.json" = "tsconfig.*.json";
        };

        "git.enabled" = true;
        "git.autoRepositoryDetection" = false;
        "git.openRepositoryInParentFolders" = "never";

        "breadcrumbs.enabled" = false;
        "problems.decorations.enabled" = false;
        "chat.commandCenter.enabled" = false;

        "search.showLineNumbers" = true;
        "search.followSymlinks" = false;
        "search.searchOnType" = false;
        "search.exclude" = {
          "**/.git" = true;
          "**/.cmake" = true;
          "**/CMakeFiles" = true;
          "**/node_modules" = true;
          "**/build" = true;
        };

        "debug.terminal.clearBeforeReusing" = true;

        "security.workspace.trust.emptyWindow" = false;

        "extensions.autoCheckUpdates" = false;
        "settingsSync.ignoredExtensions" = [];
        "settingsSync.ignoredSettings" = [];

        "html.format.indentInnerHtml" = true;
        "html.format.templating" = true;

        "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
        "javascript.inlayHints.parameterTypes.enabled" = true;
        "javascript.inlayHints.propertyDeclarationTypes.enabled" = true;
        "javascript.inlayHints.variableTypes.enabled" = true;

        "typescript.inlayHints.enumMemberValues.enabled" = true;
        "typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
        "typescript.inlayHints.parameterTypes.enabled" = true;
        "typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
        "typescript.inlayHints.variableTypes.enabled" = true;
        "typescript.inlayHints.variableTypes.suppressWhenTypeMatchesName" = false;

        "github.copilot.enable" = { "*" = false; "markdown" = true; };
      };

      # https://home-manager-options.extranix.com/?query=programs.vscode.profiles.%3Cname%3E.keybindings
      keybindings = [
        # duplicate line
        { key = "ctrl+d"; command = "editor.action.copyLinesDownAction"; when = "editorTextFocus && !editorReadonly"; }
        { key = "shift+alt+down"; command = "-editor.action.copyLinesDownAction"; }

        # terminal
        { key = "ctrl+`"; command = "workbench.action.togglePanel"; }
        { key = "ctrl+j"; command = "-workbench.action.togglePanel"; }
        { key = "ctrl+alt+j"; command = "workbench.action.terminal.new"; }
        { key = "ctrl+shift+j"; command = "workbench.action.terminal.killAll"; }
        { key = "ctrl+alt+t"; command = "workbench.action.terminal.moveIntoNewWindow"; }

        # navigation
        { key = "ctrl+j"; command = "workbench.action.quickOpenSelectNext"; when = "inQuickOpen"; }
        { key = "ctrl+k"; command = "workbench.action.quickOpenSelectPrevious"; when = "inQuickOpen"; }
        { key = "ctrl+j"; command = "selectNextSuggestion"; when = "suggestWidgetVisible && textInputFocus"; }
        { key = "ctrl+k"; command = "selectPrevSuggestion"; when = "suggestWidgetVisible && textInputFocus"; }
        { key = "ctrl+l"; command = "acceptSelectedSuggestion"; when = "suggestWidgetVisible && textInputFocus"; }
        { key = "ctrl+j"; command = "showNextParameterHint"; when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible"; }
        { key = "ctrl+k"; command = "showPrevParameterHint"; when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible"; }
        { key = "ctrl+j"; command = "selectNextCodeAction"; when = "codeActionMenuVisible"; }
        { key = "ctrl+k"; command = "selectPrevCodeAction"; when = "codeActionMenuVisible"; }
        { key = "ctrl+l"; command = "acceptSelectedCodeAction"; when = "codeActionMenuVisible"; }

        # file operations
        { key = "ctrl+n"; command = "explorer.newFile"; }
        { key = "ctrl+shift+n"; command = "explorer.newFolder"; }
        { key = "ctrl+shift+d"; command = "moveFileToTrash"; when = "filesExplorerFocus && !inputFocus"; }
        { key = "ctrl+shift+r"; command = "renameFile"; when = "filesExplorerFocus && !inputFocus"; }
        { key = "ctrl+shift+c"; command = "workbench.files.action.collapseExplorerFolders"; }

        # cursor home/end
        { key = "ctrl+1"; command = "cursorHome"; when = "textInputFocus"; }
        { key = "ctrl+shift+1"; command = "cursorHomeSelect"; when = "textInputFocus"; }
        { key = "ctrl+3"; command = "cursorEnd"; when = "textInputFocus"; }
        { key = "ctrl+shift+3"; command = "cursorEndSelect"; when = "textInputFocus"; }

        # page navigation
        { key = "ctrl+up"; command = "cursorPageUp"; when = "textInputFocus"; }
        { key = "ctrl+down"; command = "cursorPageDown"; when = "textInputFocus"; }
        { key = "ctrl+shift+up"; command = "cursorPageUpSelect"; when = "textInputFocus"; }
        { key = "ctrl+shift+down"; command = "cursorPageDownSelect"; when = "textInputFocus"; }
        { key = "ctrl+alt+up"; command = "cursorTop"; when = "textInputFocus"; }
        { key = "ctrl+alt+down"; command = "cursorBottom"; when = "textInputFocus"; }
        { key = "ctrl+shift+alt+up"; command = "cursorTopSelect"; when = "textInputFocus"; }
        { key = "ctrl+shift+alt+down"; command = "cursorBottomSelect"; when = "textInputFocus"; }

        # word navigation
        { key = "ctrl+left"; command = "cursorWordStartLeft"; }
        { key = "ctrl+right"; command = "cursorWordStartRight"; }
        { key = "ctrl+shift+left"; command = "cursorWordStartLeftSelect"; }
        { key = "ctrl+shift+right"; command = "cursorWordStartRightSelect"; }
        { key = "ctrl+alt+left"; command = "cursorWordPartLeft"; }
        { key = "ctrl+alt+right"; command = "cursorWordPartRight"; }
        { key = "ctrl+shift+alt+left"; command = "cursorWordPartLeftSelect"; }
        { key = "ctrl+shift+alt+right"; command = "cursorWordPartRightSelect"; }

        # line movement
        { key = "alt+up"; command = "editor.action.moveLinesUpAction"; when = "editorTextFocus && !editorReadonly"; }
        { key = "alt+down"; command = "editor.action.moveLinesDownAction"; when = "editorTextFocus && !editorReadonly"; }

        # editor groups
        { key = "ctrl+2"; command = "workbench.action.focusRightGroup"; }
        { key = "ctrl+shift+2"; command = "workbench.action.focusSecondEditorGroup"; }
        { key = "ctrl+alt+a"; command = "workbench.action.navigateLeft"; }
        { key = "ctrl+alt+d"; command = "workbench.action.navigateRight"; }
        { key = "ctrl+alt+1"; command = "workbench.action.minimizeOtherEditors"; }
        { key = "ctrl+alt+w"; command = "workbench.action.closeEditorsAndGroup"; }
        { key = "ctrl+shift+1"; command = "workbench.action.moveActiveEditorGroupLeft"; }
        { key = "ctrl+shift+2"; command = "workbench.action.moveActiveEditorGroupRight"; }

        # quick actions
        { key = "ctrl+."; command = "editor.action.showHover"; when = "editorTextFocus"; }
        { key = "ctrl+'"; command = "editor.action.quickFix"; when = "editorHasCodeActionsProvider && textInputFocus"; }
        { key = "ctrl+e"; command = "extension.selectDoubleQuote"; when = "editorFocus"; }
        { key = "ctrl+shift+q"; command = "workbench.action.focusFirstEditorGroup"; }

        # indentation
        { key = "shift+tab"; command = "editor.action.indentLines"; when = "editorTextFocus && !editorReadonly"; }

        # inline suggestions
        { key = "ctrl+\\"; command = "editor.action.inlineSuggest.trigger"; when = "editorTextFocus && !editorHasSelection && !inlineSuggestionsVisible"; }

        # bookmarks
        { key = "alt+."; command = "bookmarks.toggle"; when = "editorTextFocus"; }
        { key = "ctrl+alt+."; command = "bookmarks.jumpToNext"; when = "editorTextFocus"; }
        { key = "ctrl+shift+alt+."; command = "bookmarks.jumpToPrevious"; when = "editorTextFocus"; }
        { key = "alt+backspace"; command = "bookmarks.clear"; }

        # misc
        { key = "ctrl+alt+5"; command = "workbench.action.editor.changeEOL"; }
      ];
    };

  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault prefs.editor;
    VISUAL = lib.mkDefault prefs.editor;
  };
}
