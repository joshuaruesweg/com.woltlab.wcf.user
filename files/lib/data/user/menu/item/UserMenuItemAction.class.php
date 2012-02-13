<?php
namespace wcf\data\user\menu\item;
use wcf\data\AbstractDatabaseObjectAction;

/**
 * Executes user menu item-related actions.
 * 
 * @author	Alexander Ebert
 * @copyright	2001-2012 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.woltlab.wcf.user
 * @subpackage	data.user.menu.item
 * @category 	Community Framework
 */
class UserMenuItemAction extends AbstractDatabaseObjectAction {
	/**
	 * @see wcf\data\AbstractDatabaseObjectAction::$className
	 */
	protected $className = 'wcf\data\user\menu\item\UserMenuItemEditor';
}
