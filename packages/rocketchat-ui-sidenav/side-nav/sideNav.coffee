Template.sideNav.helpers
	flexTemplate: ->
		return SideNav.getFlex().template

	flexData: ->
		return SideNav.getFlex().data

	footer: ->
		sSiteName = RocketChat.settings.get 'Site_Name'
		sDolphinUrl = RocketChat.settings.get 'API_Dolphin_URL'
		sTridentUrl = RocketChat.settings.get 'API_Trident_URL'
		sSideNavFooter = RocketChat.settings.get 'Layout_Sidenav_Footer'
		if sSideNavFooter.length
			return sSideNavFooter
		else if sDolphinUrl.length and 0 == sTridentUrl.length
			'<div style="height:50%; width:100%; position:relative;"><a style="display:block; text-align:center; width:100%; position:absolute; bottom:0; right:0; line-height:0;" href="' + sDolphinUrl + '" target="_blank">' + t("Goto_main_site") + '</a></div>'
		else if sTridentUrl.length and 0 == sDolphinUrl.length
			'<div style="height:50%; width:100%; position:relative;"><a style="display:block; text-align:center; width:100%; position:absolute; bottom:0; right:0; line-height:0;" href="' + sTridentUrl + '" target="_blank">' + t("Goto_main_site") + '</a></div>'
			
	showStarredRooms: ->
		favoritesEnabled = RocketChat.settings.get 'Favorite_Rooms'
		hasFavoriteRoomOpened = ChatSubscription.findOne({ f: true, open: true })

		return true if favoritesEnabled and hasFavoriteRoomOpened

	roomType: ->
		return RocketChat.roomTypes.getTypes()

	canShowRoomType: ->
		userPref = Meteor.user()?.settings?.preferences?.mergeChannels
		globalPref = RocketChat.settings.get('UI_Merge_Channels_Groups')
		mergeChannels = if userPref? then userPref else globalPref
		if mergeChannels
			return RocketChat.roomTypes.checkCondition(@) and @template isnt 'privateGroups'
		else
			return RocketChat.roomTypes.checkCondition(@)

	templateName: ->
		userPref = Meteor.user()?.settings?.preferences?.mergeChannels
		globalPref = RocketChat.settings.get('UI_Merge_Channels_Groups')
		mergeChannels = if userPref? then userPref else globalPref
		if mergeChannels
			return if @template is 'channels' then 'combined' else @template
		else
			return @template

Template.sideNav.events
	'click .close-flex': ->
		SideNav.closeFlex()

	'click .arrow': ->
		SideNav.toggleCurrent()

	'mouseenter .header': ->
		SideNav.overArrow()

	'mouseleave .header': ->
		SideNav.leaveArrow()

	'scroll .rooms-list': ->
		menu.updateUnreadBars()

	'dropped .side-nav': (e) ->
		e.preventDefault()

Template.sideNav.onRendered ->
	SideNav.init()
	menu.init()

	Meteor.defer ->
		menu.updateUnreadBars()
