<?php
namespace wcf\acp\form;
use wcf\data\package\PackageCache;
use wcf\data\user\group\UserGroup;
use wcf\data\user\rank\UserRankEditor;
use wcf\data\user\rank\UserRankAction;
use wcf\system\exception\UserInputException;
use wcf\system\language\I18nHandler;
use wcf\system\Regex;
use wcf\system\WCF;
use wcf\util\StringUtil;

/**
 * Shows the user rank add form.
 * 
 * @author	Marcel Werk
 * @copyright	2001-2012 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.woltlab.wcf.user
 * @subpackage	acp.form
 * @category	Community Framework
 */
class UserRankAddForm extends ACPForm {
	/**
	 * @see	wcf\acp\form\ACPForm::$activeMenuItem
	 */
	public $activeMenuItem = 'wcf.acp.menu.link.user.rank.add';
	
	/**
	 * @see	wcf\page\AbstractPage::$neededPermissions
	 */
	public $neededPermissions = array('admin.user.rank.canManageRank');
	
	/**
	 * rank group id
	 * @var	integer
	 */
	public $groupID = 0;
	
	/**
	 * rank title
	 * @var	string
	 */
	public $rankTitle = '';
	
	/**
	 * CSS class name
	 * @var	string
	 */
	public $cssClassName = '';
	
	/**
	 * custom CSS class name
	 * @var	string
	 */
	public $customCssClassName = '';
	
	/**
	 * required activity points to acquire the rank
	 * @var	integer
	 */
	public $neededPoints = 0;
	
	/**
	 * path to user rank image
	 * @var	string
	 */
	public $rankImage = '';
	
	/**
	 * number of image repeats
	 * @var	integer
	 */
	public $repeatImage = 1;
	
	/**
	 * gender setting (1=male; 2=female)
	 * @var	integer
	 */
	public $gender = 0;
	
	/**
	 * list of pre-defined css class names
	 * @var	array<string>
	 */
	public $availableCssClassNames = array(
		'yellow',
		'orange',
		'brown',
		'red',
		'pink',
		'purple',
		'blue',
		'green',
		'black',
		
		'none', /* not a real value */
		'custom' /* not a real value */
	);
	
	/**
	 * @see	wcf\page\IPage::readParameters()
	 */
	public function readParameters() {
		parent::readParameters();
		
		I18nHandler::getInstance()->register('rankTitle');
	}
	
	/**
	 * @see	wcf\form\IForm::readFormParameters()
	 */
	public function readFormParameters() {
		parent::readFormParameters();
		
		I18nHandler::getInstance()->readValues();
		
		if (I18nHandler::getInstance()->isPlainValue('rankTitle')) $this->rankTitle = I18nHandler::getInstance()->getValue('rankTitle');
		if (isset($_POST['cssClassName'])) $this->cssClassName = StringUtil::trim($_POST['cssClassName']);
		if (isset($_POST['customCssClassName'])) $this->customCssClassName = StringUtil::trim($_POST['customCssClassName']);
		if (isset($_POST['groupID'])) $this->groupID = intval($_POST['groupID']);
		if (isset($_POST['neededPoints'])) $this->neededPoints = intval($_POST['neededPoints']);
		if (isset($_POST['rankImage'])) $this->rankImage = StringUtil::trim($_POST['rankImage']);
		if (isset($_POST['repeatImage'])) $this->repeatImage = intval($_POST['repeatImage']);
		if (isset($_POST['gender'])) $this->gender = intval($_POST['gender']);
	}
	
	/**
	 * @see	wcf\form\IForm::validate()
	 */
	public function validate() {
		parent::validate();
		
		// validate label
		if (!I18nHandler::getInstance()->validateValue('rankTitle')) {
			if (I18nHandler::getInstance()->isPlainValue('rankTitle')) {
				throw new UserInputException('rankTitle');
			}
			else {
				throw new UserInputException('rankTitle', 'multilingual');
			}
		}
		
		// validate group
		if (!$this->groupID) {
			throw new UserInputException('groupID');
		}
		$userGroup = UserGroup::getGroupByID($this->groupID);
		if ($userGroup === null || ($userGroup->groupType != UserGroup::USERS && $userGroup->groupType != UserGroup::OTHER)) {
			throw new UserInputException('groupID', 'invalid');
		}
		
		// css class name
		if (empty($this->cssClassName)) {
			throw new UserInputException('cssClassName', 'empty');
		}
		else if (!in_array($this->cssClassName, $this->availableCssClassNames)) {
			throw new UserInputException('cssClassName', 'notValid');
		}
		else if ($this->cssClassName == 'custom') {
			if (!empty($this->customCssClassName) && !Regex::compile('^-?[_a-zA-Z]+[_a-zA-Z0-9-]+$')->match($this->customCssClassName)) {
				throw new UserInputException('cssClassName', 'notValid');
			}
		}
		
		// gender
		if ($this->gender < 0 || $this->gender > 2) {
			$this->gender = 0;
		}
	}
	
	/**
	 * @see	wcf\form\IForm::save()
	 */
	public function save() {
		parent::save();
		
		// save label
		$this->objectAction = new UserRankAction(array(), 'create', array('data' => array(
			'rankTitle' => $this->rankTitle,
			'cssClassName' => ($this->cssClassName == 'custom' ? $this->customCssClassName : $this->cssClassName),
			'groupID' => $this->groupID,
			'neededPoints' => $this->neededPoints,
			'rankImage' => $this->rankImage,
			'repeatImage' => $this->repeatImage,
			'gender' => $this->gender
		)));
		$this->objectAction->executeAction();
		
		if (!I18nHandler::getInstance()->isPlainValue('rankTitle')) {
			$returnValues = $this->objectAction->getReturnValues();
			$rankID = $returnValues['returnValues']->rankID;
			I18nHandler::getInstance()->save('rankTitle', 'wcf.user.rank.userRank'.$rankID, 'wcf.user', PackageCache::getInstance()->getPackageID('com.woltlab.wcf.user'));
			
			// update name
			$rankEditor = new UserRankEditor($returnValues['returnValues']);
			$rankEditor->update(array(
				'rankTitle' => 'wcf.user.rank.generic'.$rankID
			));
		}
		$this->saved();
		
		// reset values
		$this->rankTitle = $this->cssClassName = $this->customCssClassName = $this->rankImage = '';
		$this->groupID = $this->repeatImage = $this->neededPoints = $this->gender = 0;
		I18nHandler::getInstance()->disableAssignValueVariables();
		
		// show success
		WCF::getTPL()->assign(array(
			'success' => true
		));
	}
	
	/**
	 * @see	wcf\page\IPage::assignVariables()
	 */
	public function assignVariables() {
		parent::assignVariables();
		
		I18nHandler::getInstance()->assignVariables();
		
		WCF::getTPL()->assign(array(
			'action' => 'add',
			'availableCssClassNames' => $this->availableCssClassNames,
			'cssClassName' => $this->cssClassName,
			'customCssClassName' => $this->customCssClassName,
			'groupID' => $this->groupID,
			'rankTitle' => $this->rankTitle,
			'availableGroups' => UserGroup::getGroupsByType(array(UserGroup::USERS, UserGroup::OTHER)),
			'neededPoints' => $this->neededPoints,
			'rankImage' => $this->rankImage,
			'repeatImage' => $this->repeatImage,
			'gender' => $this->gender
		));
	}
}
