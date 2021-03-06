{if $__wcf->user->userID}
	<!-- user menu -->
	<li id="userMenu" class="dropdown">
		<a class="dropdownToggle framed" data-toggle="userMenu">{@$__wcf->getUserProfileHandler()->getAvatar()->getImageTag(24)} {lang}wcf.user.userNote{/lang}</a>
		<ul class="dropdownMenu">
			<li><a href="{link controller='User' object=$__wcf->user}{/link}" class="box32">
				<div class="framed">{@$__wcf->getUserProfileHandler()->getAvatar()->getImageTag(32)}</div>
				
				<hgroup class="containerHeadline">
					<h1>{$__wcf->user->username}</h1>
					<h2>{lang}wcf.user.myProfile{/lang}</h2>
				</hgroup>
			</a></li>
			{if $__wcf->getUserProfileHandler()->canEditOwnProfile()}<li><a href="{link controller='User' object=$__wcf->user}editOnInit=true#about{/link}">{lang}wcf.user.editProfile{/lang}</a></li>{/if}
			<li><a href="{link controller='Settings'}{/link}">{lang}wcf.user.menu.settings{/lang}</a></li>
			{if $__wcf->session->getPermission('admin.general.canUseAcp')}
				<li class="dropdownDivider"></li>
				<li><a href="acp/index.php">ACP</a></li>
			{/if}
			<li class="dropdownDivider"></li>
			<li><a href="{link controller='Logout'}t={@SECURITY_TOKEN}{/link}" onclick="WCF.System.Confirmation.show('{lang}wcf.user.logout.sure{/lang}', $.proxy(function (action) { if (action == 'confirm') window.location.href = $(this).attr('href'); }, this)); return false;">{lang}wcf.user.logout{/lang}</a></li>
		</ul>
	</li>
	
	<!-- user notifications -->
	<li id="userNotifications" class="dropdown" data-count="{#$__wcf->getUserNotificationHandler()->getNotificationCount()}" data-link="{link controller='NotificationList'}{/link}">
		<a href="{link controller='NotificationList'}{/link}"><span class="icon icon16 icon-bell-alt"></span> <span>{lang}wcf.user.notification.notifications{/lang}</span>{if $__wcf->getUserNotificationHandler()->getNotificationCount()} <span class="badge badgeInverse">{#$__wcf->getUserNotificationHandler()->getNotificationCount()}</span>{/if}</a>
		<script type="text/javascript">
			//<![CDATA[
			$(function() {
				new WCF.Notification.Handler();
			});
			//]]>
		</script>
	</li>
{else}
	{if !$__disableLoginLink|isset}
		<!-- login box -->
		<li>
			<a class="loginLink" href="{link controller='Login'}{/link}">{lang}wcf.user.loginOrRegister{/lang}</a>
			<div id="loginForm" style="display: none;">
				<form method="post" action="{link controller='Login'}{/link}">
					<fieldset>
						<dl>
							<dt><label for="username">{lang}wcf.user.usernameOrEmail{/lang}</label></dt>
							<dd>
								<input type="text" id="username" name="username" value="" required="required" autofocus="autofocus" class="long" />
							</dd>
						</dl>
						
						{if !REGISTER_DISABLED}
							<dl>
								<dt>{lang}wcf.user.login.action{/lang}</dt>
								<dd>
									<label><input type="radio" name="action" value="register" /> {lang}wcf.user.login.action.register{/lang}</label>
									<label><input type="radio" name="action" value="login" checked="checked" /> {lang}wcf.user.login.action.login{/lang}</label>
								</dd>
							</dl>
						{/if}
						
						<dl>
							<dt><label for="password">{lang}wcf.user.password{/lang}</label></dt>
							<dd>
								<input type="password" id="password" name="password" value="" class="long" />
							</dd>
						</dl>
						
						<dl>
							<dd><label><input type="checkbox" id="useCookies" name="useCookies" value="1" checked="checked" /> {lang}wcf.user.useCookies{/lang}</label></dd>
						</dl>
						
						{event name='additionalLoginFields'}
						
						<div class="formSubmit">
							<input type="submit" id="loginSubmitButton" name="submitButton" value="{lang}wcf.user.button.login{/lang}" accesskey="s" />
							<input type="hidden" name="url" value="{$__wcf->session->requestURI}" />
						</div>
					</fieldset>
				</form>
			</div>
			
			<script type="text/javascript">
				//<![CDATA[
				$(function() {
					WCF.Language.addObject({
						'wcf.user.button.login': '{lang}wcf.user.button.login{/lang}',
						'wcf.user.button.register': '{lang}wcf.user.button.register{/lang}',
						'wcf.user.login': '{lang}wcf.user.login{/lang}'
					});
					new WCF.User.Login(true);
				});
				//]]>
			</script>
		</li>
	{/if}
	<!-- language switcher -->
	<li id="pageLanguageContainer">
		<script type="text/javascript">
			//<![CDATA[
			$(function() {
				var $languages = {
					{implode from=$__wcf->getLanguage()->getLanguages() item=language}
						'{@$language->languageID}': {
							iconPath: '{@$language->getIconPath()}',
							languageName: '{$language}'
						}
					{/implode}
				};
				
				new WCF.Language.Chooser('pageLanguageContainer', 'languageID', {@$__wcf->getLanguage()->languageID}, $languages, function(item) {
					var $location = window.location.toString().replace(/#.*/, '').replace(/(\?|&)l=[0-9]+/g, '');
					var $delimiter = ($location.indexOf('?') == -1) ? '?' : '&';
					
					window.location = $location + $delimiter + 'l=' + item.data('languageID') + window.location.hash;
				});
			});
			//]]>
		</script>
	</li>
{/if}

{event name='menuItems'}
