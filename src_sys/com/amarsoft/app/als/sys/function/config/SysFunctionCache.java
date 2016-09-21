package com.amarsoft.app.als.sys.function.config;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class SysFunctionCache extends AbstractCache{

	private static BusinessObjectCache roleMenuCache;
	private static BusinessObjectCache functionCache;
	
	private static SysFunctionCache instance = null;
	@Override
	public void clear() throws Exception {
		functionCache.clear();
		roleMenuCache.clear();
	}

	@Override
	public boolean load(Transaction sqlca) throws Exception {
		ARE.getLog().debug("SysFunction Config bulid Begin");
		functionCache=new BusinessObjectCache(5000);
		roleMenuCache=new BusinessObjectCache(5000);
		ARE.getLog().debug("SysFunction Config bulid END");
		return true;
	}
	
	/**
	 * ��ù��ܵ���Ϣ
	 * @param functionid
	 * @return
	 * @throws Exception
	 */
	public static List<BusinessObject> getSysFunctionLibrary(String functionid) throws Exception{
		return getSysFunctionCataLog(functionid).getBusinessObjects("jbo.sys.SYS_FUNCTION_LIBRARY");
	}
	
	/**
	 * ��ù��ܵ���Ϣ
	 * @param functionid
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getSysFunctionCataLog(String functionid) throws Exception{
		BusinessObject function=(BusinessObject)functionCache.getCacheObject(functionid);
		if(function==null){
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
			function=bomanager.loadBusinessObject("jbo.sys.SYS_FUNCTION_CATALOG","FunctionID", functionid);
			List<BusinessObject> functionItemList = bomanager.loadBusinessObjects("jbo.sys.SYS_FUNCTION_LIBRARY", "FunctionID=:FunctionID and IsInUse='1' order by FUNCTIONID,SortNo","FunctionID",functionid);
			function.appendBusinessObjects("jbo.sys.SYS_FUNCTION_LIBRARY", functionItemList);
			functionCache.setCache(functionid, function);
		}
		return function;
	}
	
	public static List<BusinessObject> getRoleMenus(String roleID) throws Exception{
		List<BusinessObject> roleMenus=(List<BusinessObject>)roleMenuCache.getCacheObject(roleID);
		if(roleMenus==null){
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
			roleMenus = bomanager.loadBusinessObjects("jbo.awe.AWE_ROLE_MENU", "RoleID=:RoleID ","RoleID",roleID);
			roleMenuCache.setCache(roleID, roleMenus);
		}
		return roleMenus;
	}
	
	/**
	 * ÿ��ʹ�õ�ʱ��,�ܹ����ñ�����,���õ�ȫ��Ψһ�Ķ���ʵ������ 
	 * @return RoleCache ����һ��ȫ��Ψһ�Ķ���ʵ������
	 */
	public static synchronized SysFunctionCache getInstance() {
		if (instance == null) {
			instance = new SysFunctionCache();
		}
		return instance;
	}

}
