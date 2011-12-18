{include file='documentHeader'}

<head>
	<title>User profile page</title>
	{include file='headInclude' sandbox=false}

	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/WCF.User.Profile.js"></script>
	<script type="text/javascript">
		//<![CDATA[
		$(function() {
			{if $__wcf->getUser()->userID != $user->userID}
				WCF.Language.addObject({
					'wcf.user.profile.followUser': 'follow',
					'wcf.user.profile.unfollowUser': 'unfollow',
					'wcf.user.profile.ignoreUser': 'ignore user',
					'wcf.user.profile.unignoreUser': 'unignore user'
				});

				new WCF.User.Profile.Follow({$user->userID}, {if $__wcf->getUserProfileHandler()->isFollowing($user->userID)}true{else}false{/if});
				new WCF.User.Profile.IgnoreUser({@$user->userID}, {if $__wcf->getUserProfileHandler()->isIgnoredUser($user->userID)}true{else}false{/if});
			{/if}

			new WCF.User.Profile.TabMenu({@$user->userID});

			WCF.TabMenu.init();

			{* TODO: Handle admin permissions *}
			{if $__wcf->getUser()->userID == $user->userID}
				WCF.User.Profile.Editor.Handler.init({$user->userID});
				new WCF.User.Profile.Editor.Overview({@$overviewObjectType->objectTypeID});
			{/if}
		});
		//]]>
	</script>
</head>

<body{if $templateName|isset} id="tpl{$templateName|ucfirst}"{/if}>

{capture assign='sidebar'}
<div class="userAvatar">{if $user->getAvatar()}{assign var=__dummy value=$user->getAvatar()->setMaxSize(150, 150)}{@$user->getAvatar()}{/if}</div>
{/capture}

{include file='header' sandbox=false sidebarDirection='left'}

<div class="contentHeader">
	<!-- ToDo: Wouldn't it be better to generate a Large Button List out of all that here? -->
	<nav id="profileButtonContainer">
	</nav>
</div>
	
<section id="profileContent" class="tabMenuContainer" data-active="{$__wcf->getUserProfileMenu()->getActiveMenuItem()->getIdentifier()}">
	<nav class="tabMenu">
		<ul>
			{foreach from=$__wcf->getUserProfileMenu()->getMenuItems() item=menuItem}
				<li><a href="#{$menuItem->getIdentifier()}" title="{lang}{@$menuItem->menuItem}{/lang}">{lang}{@$menuItem->menuItem}{/lang}</a></li>
			{/foreach}
		</ul>
	</nav>

	{foreach from=$__wcf->getUserProfileMenu()->getMenuItems() item=menuItem}
		<div id="{$menuItem->getIdentifier()}" class="border tabMenuContent" data-menu-item="{$menuItem->menuItem}">
			{if $menuItem === $__wcf->getUserProfileMenu()->getActiveMenuItem()}
				{@$profileContent}
			{/if}
		</div>
	{/foreach}
</section>

<div class="contentFooter">
	<!-- ToDo -->
</div>

{include file='footer' sandbox=false}

</body>
</html>
