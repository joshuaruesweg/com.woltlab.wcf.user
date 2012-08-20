{include file='documentHeader'}

<head>
	<title>{lang}wcf.user.avatar.edit{/lang} - {lang}wcf.user.usercp{/lang} - {PAGE_TITLE|language}</title>
	
	{include file='headInclude'}
</head>

<body id="tpl{$templateName|ucfirst}">

{include file='userMenuSidebar'}

{include file='header' sidebarOrientation='left'}

<header class="boxHeadline">
	<hgroup>
		<h1>{lang}wcf.user.avatar.edit{/lang}</h1>
	</hgroup>
</header>

{include file='userNotice'}

{if $errorField}
	<p class="error">{lang}wcf.global.form.error{/lang}</p>
{/if}

{if $success|isset}
	<p class="success">{lang}wcf.global.form.edit.success{/lang}</p>	
{/if}

<form method="post" action="{link controller='AvatarEdit'}{/link}">
	<div class="container containerPadding marginTop shadow">
		<fieldset>
			<legend><label for="password">{lang}wcf.user.avatar{/lang}</label></legend>
				
			<dl>
				<dd>
					<label><input type="radio" name="avatarType" value="none" {if $avatarType == 'none'}checked="checked" {/if}/> {lang}wcf.user.avatar.type.none{/lang}</label>
					<small>{lang}wcf.user.avatar.type.none.description{/lang}</small>
				</dd>
			</dl>
			
			<dl{if $errorField == 'custom'} class="formError"{/if} id="avatarUpload">
				<dt class="framed">{if $avatarType == 'custom'}{@$__wcf->getUserProfileHandler()->getAvatar()->getImageTag(96)}{else}<img src="{@$__wcf->getPath()}images/avatars/avatar-default.svg" alt="" class="icon96" />{/if}</dt>
				<dd>
					<label><input type="radio" name="avatarType" value="custom" {if $avatarType == 'custom'}checked="checked" {/if}/> {lang}wcf.user.avatar.type.custom{/lang}</label>
					<small>{lang}wcf.user.avatar.type.custom.description{/lang}</small>
					
					{* placeholder for upload button: *}
					<div></div>
					
					{if $errorField == 'custom'}
						<small class="innerError">
							{if $errorType == 'empty'}{lang}wcf.global.form.error.empty{/lang}{/if}
						</small>
					{/if}
				</dd>
			</dl>
			
			{if MODULE_GRAVATAR}
				<dl{if $errorField == 'gravatar'} class="formError"{/if}>
					<dt class="framed"><img src="http://www.gravatar.com/avatar/{@$__wcf->user->email|strtolower|md5}?s=96" /></dt>
					<dd>
						<label><input type="radio" name="avatarType" value="gravatar" {if $avatarType == 'gravatar'}checked="checked" {/if}/> {lang}wcf.user.avatar.type.gravatar{/lang}</label>
						<small>{lang}wcf.user.avatar.type.gravatar.description{/lang}</small>
						
						{if $errorField == 'gravatar'}
							<small class="innerError">
								{if $errorType == 'notFound'}{lang}wcf.user.avatar.type.gravatar.error.notFound{/lang}{/if}
							</small>
						{/if}
					</dd>
				</dl>
			{/if}
		</fieldset>
	</div>
		
	<div class="formSubmit">
		<input type="submit" value="{lang}wcf.global.button.submit{/lang}" accesskey="s" />
	</div>
</form>

{include file='footer'}

<script type="text/javascript">
	//<![CDATA[
	$(function() {
		{*WCF.Language.addObject({
			
		});*}

		new WCF.User.Avatar.Upload();
	});
	//]]>
</script>

</body>
</html>