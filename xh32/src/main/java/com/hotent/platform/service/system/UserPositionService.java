package com.hotent.platform.service.system;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.hotent.core.db.IEntityDao;
import com.hotent.core.service.BaseService;
import com.hotent.core.util.BeanUtils;
import com.hotent.core.util.StringUtil;
import com.hotent.core.util.UniqueIdUtil;
import com.hotent.platform.model.system.Position;
import com.hotent.platform.model.system.SysOrg;
import com.hotent.platform.model.system.SysUser;
import com.hotent.platform.model.system.SysUserOrg;
import com.hotent.platform.model.system.UserPosition;
import com.hotent.platform.service.util.ServiceUtil;
import com.hotent.platform.dao.system.PositionDao;
import com.hotent.platform.dao.system.SysOrgDao;
import com.hotent.platform.dao.system.SysOrgTypeDao;
import com.hotent.platform.dao.system.SysUserDao;
import com.hotent.platform.dao.system.UserPositionDao;
import com.hotent.platform.service.util.ServiceUtil;
/**
 *<pre>
 * 对象功能:SYS_USER_POS Service类
 * 开发公司:广州宏天软件有限公司
 * 开发人员:ray
 * 创建时间:2013-11-27 10:19:23
 *</pre>
 */
@Service
public class UserPositionService extends BaseService<UserPosition>
{
	@Resource
	private UserPositionDao userPositionDao;
	@Resource
	private PositionService positionService;
	@Resource
	private SysOrgDao sysOrgDao;
	@Resource
	private SysUserDao sysUserDao;
	@Resource
	private PositionDao positionDao;
	@Resource
	private SysOrgTypeDao sysOrgTypeDao;
	protected static Logger logger = LoggerFactory.getLogger(SysUserOrgService.class);
	
	
	public UserPositionService()
	{
	}
	
	@Override
	protected IEntityDao<UserPosition, Long> getEntityDao() 
	{
		return userPositionDao;
	}
	
	/**
	 * 取得某个职位下的所有用户ID
	 * @param posId
	 * @return
	 */
	public List<Long> getUserIdsByPosId(Long posId)
	{
		return userPositionDao.getUserIdsByPosId(posId);
	}
	

	
	/**
	 * 根据userId得到岗位
	 * @param param
	 * @return
	 */
	public List<UserPosition> getByUserId(Long userId)
	{ 
		return userPositionDao.getByUserId(userId);
	}
	

	/**
	 * 根据userId得用户组织列表，
	 * 组织不重复，但岗位ID和主键都为null
	 * @param param
	 * @return
	 */
	public List<UserPosition> getOrgListByUserId(Long userId)
	{ 
		
		return userPositionDao.getOrgListByUserId(userId);
	}
	
	/**
	 * 根据posId得用户组织列表，
	 * 
	 * @param param
	 * @return
	 */
	public List<UserPosition> getByPosId(Long posId)
	{ 
		return userPositionDao.getByPosId(posId);
	}
		
	
	/**
	 * 根据userId删除用户岗位关系
	 * @param param
	 * @return
	 */
	public void delByUserId(Long userId)
	{ 
		userPositionDao.delByUserId(userId);
	}
	

	/**
	 * 获取用户的主岗位关系(没有主岗位则返回任一岗位)
	 * 主岗位对应的就是主组织
	 * @param userId
	 *            用户ID
	 * @return
	 */
	public UserPosition getPrimaryUserPositionByUserId(Long userId) {
		return userPositionDao.getPrimaryUserPositionByUserId(userId);
	}
	
	/**
	 * 根据组织id串得到用户和组织及岗位的关系
	 * @author hjx
	 * @version 创建时间：2013-11-27  下午3:16:17
	 * @param orgIds
	 * @return
	 */
	public List<UserPosition> getUserByOrgIds(String orgIds){
		return  userPositionDao.getUserByOrgIds(orgIds);
	}
	
	public List<SysUser> getLeaderUserByOrgId(Long orgId,boolean upslope) {
		List<UserPosition> list= userPositionDao.getChargeByOrgId(orgId);
		if(BeanUtils.isNotEmpty(list)){
			List<SysUser> users=new ArrayList<SysUser>();
			for(UserPosition userPosition:list){
				SysUser user = sysUserDao.getById(userPosition.getUserId());
				users.add(user);
			}
			return users;
		} else {
			SysOrg sysOrg=sysOrgDao.getById(orgId);
			if(sysOrg==null)
				return new ArrayList<SysUser>();
			Long parentOrgId=sysOrg.getOrgSupId();
			SysOrg sysOrgParent=sysOrgDao.getById(parentOrgId);
			if (sysOrgParent == null) {
				return new ArrayList<SysUser>();
			} else {
				if(upslope){
					return getLeaderUserByOrgId(parentOrgId,true);
				}else{
					return new ArrayList<SysUser>();
				}
			}
		}
	}
	
	/**
	 * 根据用户ID获取可以负责的组织列表。
	 * @param userId
	 * @return
	 */
	public List<UserPosition> getChargeOrgByUserId(Long userId){
		return userPositionDao.getChargeOrgByUserId(userId);
	}
	
	/**
	 * 保存用户和岗位的映射关系。
	 * @param userId	用户ID
	 * @param posIds	岗位ID
	 * @param posIdPrimary	主岗位ID
	 * @param posIdCharge	负责人
	 * @throws Exception
	 */
	public void saveUserPos(Long userId ,Long[] OrgIds,Long[] posIds,Long posIdPrimary,Long[] posIdCharge) throws Exception
 {
		userPositionDao.delByUserId(userId);
		if (BeanUtils.isEmpty(posIds))
			return;
		Position position=new Position();
		for (int i = 0, n = posIds.length; i < n; i++) {
			UserPosition userPosition = new UserPosition();
			userPosition.setUserPosId(UniqueIdUtil.genId());
			userPosition.setOrgId(OrgIds[i]);
			userPosition.setPosId(posIds[i]);
			position=positionService.getById(posIds[i]);
			userPosition.setJobId(position.getJobId());
			userPosition.setUserId(userId);
			if (posIdPrimary != null && posIds[i].equals(posIdPrimary)) {
				userPosition.setIsPrimary(UserPosition.PRIMARY_YES);
			}
			if (posIdCharge != null && posIdCharge.length > 0) {
				for (int y = 0, m = posIdCharge.length; y < m; y++) {
					if (posIdCharge[y] != null && posIdCharge[y] == posIds[i]) {
						userPosition.setIsCharge(UserPosition.CHARRGE_YES);
					}
				}
			}
			userPositionDao.add(userPosition);
		}
	}
	
	/**
	 * 获取某用户的组织列表字符串（可能多个组织）
	 * @author hjx
	 * @version 创建时间：2013-12-4  下午4:09:36
	 * @param user
	 * @return
	 */
	public String getOrgnamesByUserId(Long userId){
		StringBuffer orgNames=new StringBuffer();
		//获取每个用户的所有组织，组织不重复
		List<UserPosition> userPositionList=this.getOrgListByUserId(userId);
		if(BeanUtils.isNotEmpty(userPositionList)){
			//循环组织，组织名拼接
			for(UserPosition userPosition:userPositionList){

				if(userPosition.getIsPrimary()!=null&&userPosition.getIsPrimary()==UserPosition.PRIMARY_YES){
					orgNames.append(userPosition.getOrgName()+getText("service.userPosition.msg")+"  ");
				}else{
					orgNames.append(userPosition.getOrgName()+"  ");
				}
			}
		}
		return orgNames.toString();
	}
	
	

	/**
	 * 获取某岗位的用户列表字符串
	 * @author hjx
	 * @version 创建时间：2013-12-4  下午4:09:36
	 * @param user
	 * @return
	 */
	public String getUsernamesByPosId(Long posId){
		StringBuffer userNames=new StringBuffer();
		List<UserPosition> userPositionList=this.getByPosId(posId);
		if(BeanUtils.isNotEmpty(userPositionList)){
			//循环组织，组织名拼接
			for(UserPosition userPosition:userPositionList){
				//取得用户链接
				userNames.append(ServiceUtil.getUserLinkOpenWindow(userPosition.getUserId().toString(),userPosition.getUserName()));
			}
		}
		return userNames.toString();
	}
	
	
	
	
	/**
	 * 添加多个人员和一个岗位的关系
	 *  @param Long[] userIds
	 *  @param Long orgId
	 */
	public void addPosUser(Long[] userIds,Long posId) throws Exception
	{
		if(BeanUtils.isEmpty(userIds)||StringUtil.isEmpty(posId.toString())) return;	
		Position position=positionService.getById(posId);
		SysUserOrg sysUserOrg =null;
		for (Long userId : userIds){
			UserPosition userPosition= userPositionDao.getUserPosModel(userId, posId);
			/*break 跳出语句块 执行下面的语句
			continue 跳出当前循环 不执行循环中continue下面的所有语句 
			开始下一次循环*/
			if(userPosition!=null) continue;
			//不存在才新增
			userPosition =new UserPosition();
			userPosition.setUserPosId(UniqueIdUtil.genId());
			userPosition.setOrgId(position.getOrgId());
			userPosition.setUserId(userId);
			userPosition.setPosId(posId);
			userPosition.setJobId(position.getJobId());
			userPositionDao.add(userPosition);
		}
	}
}
