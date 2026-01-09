# https://kaylorben.github.io/nixcord/
# TODO: consider migrating to vesktop

{ inputs, ... }: {
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord = {
      vencord.enable = true;
    };

    # https://stylix.danth.me/options/hm/targets/nixcord/
    # stylix.targets.nixcord.enable = true; # Enabled by default when Stylix is enabled

    # See more plugin at: https://kaylorben.github.io/nixcord/
    config.plugins = {
      # alwaysAnimate = { enable = true; };
      # alwaysTrust = { enable = true; };
      # anigameSolver = { enable = true; };
      # betterFolders = { enable = true; };
      # betterGifAltText = { enable = true; };
      # betterNotes = { enable = true; };
      # betterRoleContext = { enable = true; };
      # betterUploadButton = { enable = true; };
      # biggerStreamPreview = { enable = true; };
      # blurNSFW = { enable = true; };
      # callTimer = { enable = true; };
      # clearURLs = { enable = true; };
      # copyEmojiMarkdown = { enable = true; };
      # copyFileContents = { enable = true; };
      # copyUserURLs = { enable = true; };
      # crashHandler = { enable = true; };
      # customRPC = { enable = true; };
      # disableCallIdle = { enable = true; };
      # emoticonBreeder = { enable = true; };
      # fakeNitro = { enable = true; };
      # fakeProfileThemes = { enable = true; };
      # favoriteEmojiFirst = { enable = true; };
      # favoriteGifSearch = { enable = true; };
      # fixImagesQuality = { enable = true; };
      # fixSpotifyEmbeds = { enable = true; };
      # forceOwnerCrown = { enable = true; };
      # friendInvites = { enable = true; };
      # friendsSince = { enable = true; };
      # gameActivityToggle = { enable = true; };
      # gifPaste = { enable = true; };
      # greetStickerPicker = { enable = true; };
      # hideAttachments = { enable = true; };
      # iLoveSpam = { enable = true; };
      # ignoreActivities = { enable = true; };
      # imageZoom = { enable = true; };
      # keepCurrentChannel = { enable = true; };
      # lastFMRichPresence = { enable = true; };
      # loadingQuotes = { enable = true; };
      # memberCount = { enable = true; };
      # messageClickActions = { enable = true; };
      # messageLogger = { enable = true; };
      # moreKaomoji = { enable = true; };
      # moreUserTags = { enable = true; };
      # mutualGroupDMs = { enable = true; };
      # noBlockedMessages = { enable = true; };
      # noDevtoolsWarning = { enable = true; };
      # noF1 = { enable = true; };
      # noMosaic = { enable = true; };
      # noPendingCount = { enable = true; };
      # noProfileThemes = { enable = true; };
      # noTrack = { enable = true; };
      # noTypingAnimation = { enable = true; };
      # noUnblockedMessages = { enable = true; };
      # normalizeMessageLinks = { enable = true; };
      # nsfwGateBypass = { enable = true; };
      # oneKo = { enable = true; };
      # openInApp = { enable = true; };
      # permissionFreeWill = { enable = true; };
      # pictureInPicture = { enable = true; };
      # pinDMs = { enable = true; };
      # plainFolderIcon = { enable = true; };
      # platformIndicators = { enable = true; };
      # previewMessage = { enable = true; };
      # quickReply = { enable = true; };
      # readAllNotificationsButton = { enable = true; };
      # relationshipNotifier = { enable = true; };
      # resurrectHome = { enable = true; };
      # reverseImageSearch = { enable = true; };
      # reviewDB = { enable = true; };
      # roleColorEverywhere = { enable = true; };
      # searchReply = { enable = true; };
      # sendTimestamps = { enable = true; };
      # serverListIndicators = { enable = true; };
      # serverProfile = { enable = true; };
      # shikiCode = { enable = true; };
      # showHiddenChannels = { enable = true; };
      # showMeYourName = { enable = true; };
      # showTimeouts = { enable = true; };
      # silentMessageToggle = { enable = true; };
      # silentTyping = { enable = true; };
      # sortFriendRequests = { enable = true; };
      # spotifyControls = { enable = true; };
      # spotifyCrack = { enable = true; };
      # spotifyShareCommands = { enable = true; };
      # startupTimings = { enable = true; };
      # supportHelper = { enable = true; };
      # textReplace = { enable = true; };
      # themeAttributes = { enable = true; };
      # timeBarAllThings = { enable = true; };
      # translate = { enable = true; };
      # typingIndicator = { enable = true; };
      # typingTweaks = { enable = true; };
      # unsuppressEmbeds = { enable = true; };
      # urbanDictionary = { enable = true; };
      # userVoiceShow = { enable = true; };
      # usrBg = { enable = true; };
      # validUser = { enable = true; };
      # voiceChatDoubleClick = { enable = true; };
      # voiceMessages = { enable = true; };
      # volumeBooster = { enable = true; };
      # whoReacted = { enable = true; };
      # wikiSearch = { enable = true; };
    };
  };
}
