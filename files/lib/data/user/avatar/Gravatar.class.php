<?php
namespace wcf\data\user\avatar;
use wcf\system\exception\SystemException;
use wcf\util\FileUtil;
use wcf\util\StringUtil;
use wcf\system\WCF;

/**
 * Represents a gravatar.
 * 
 * @author	Marcel Werk
 * @copyright	2001-2012 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.woltlab.wcf.user
 * @subpackage	data.user.avatar
 * @category 	Community Framework
 * @see		http://www.gravatar.com
 */
class Gravatar extends DefaultAvatar {
	/**
	 * gravatar base url
	 * @var string
	 */
	const GRAVATAR_BASE = 'http://gravatar.com/avatar/%s?s=%d&r=g&d=%s';
	
	/**
	 * gravatar local cache location
	 * @var string
	 */
	const GRAVATAR_CACHE_LOCATION = 'images/avatars/gravatars/%s-%s.png';
	
	/**
	 * gravatar expire time (days)
	 * @var integer
	 */
	const GRAVATAR_CACHE_EXPIRE = 7;

	/**
	 * gravatar e-mail address
	 * @var	string
	 */
	public $gravatar = '';

	/**
	 * urls of this gravatar
	 * @var array<string>
	 */
	protected $url = array();
	
	/**
	 * Creates a new Gravatar object.
	 * 
	 * @param	string		$gravatar
	 */
	public function __construct($gravatar) {
		$this->gravatar = $gravatar;
	}
	
	/**
	 * @see	wcf\data\user\avatar\IUserAvatar::getURL()
	 */
	public function getURL($size = null) {
		if ($size === null) $size = $this->size;
		
		if (!isset($this->url[$size])) {
			// try to use cached gravatar
			$cachedFilename = sprintf(self::GRAVATAR_CACHE_LOCATION, md5(StringUtil::toLowerCase($this->gravatar)), $size);
			if (file_exists(WCF_DIR.$cachedFilename) && filemtime(WCF_DIR.$cachedFilename) > (TIME_NOW - (self::GRAVATAR_CACHE_EXPIRE * 86400))) {
				$this->url[$size] = WCF::getPath().$cachedFilename;
			}
			else {
				$gravatarURL = sprintf(self::GRAVATAR_BASE, md5(StringUtil::toLowerCase($this->gravatar)), $size, '404');
				try {
					$tmpFile = FileUtil::downloadFileFromHttp($gravatarURL, 'gravatar');
					copy($tmpFile, WCF_DIR.$cachedFilename);
					@unlink($tmpFile);
					@chmod(WCF_DIR.$cachedFilename, 0777);
					$this->url[$size] = WCF::getPath().$cachedFilename;
				}
				catch (SystemException $e) {
					$this->url[$size] = parent::getURL();
				}
			}
		}
		
		return $this->url[$size];
	}
	
	/**
	 * Checks a given email address for gravatar support.
	 * 
	 * @param	string		$email
	 * @return	boolean
	 */
	public static function test($email) {
		$gravatarURL = sprintf(self::GRAVATAR_BASE, md5(StringUtil::toLowerCase($email)), 80, '404');
		try {
			$tmpFile = FileUtil::downloadFileFromHttp($gravatarURL, 'gravatar');
			@unlink($tmpFile);
			return true;
		}
		catch (SystemException $e) {
			return false;
		}
	}
}
