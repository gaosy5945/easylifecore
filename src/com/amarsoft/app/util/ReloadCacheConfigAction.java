package com.amarsoft.app.util;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CacheLoaderFactory;

/**
 * 同步数据库与缓存中的数据，调用CacheLoaderFactory的相应方法
 * @author xhgao
 *
 */
public class ReloadCacheConfigAction {
	
	private String configName; //需要重新reload的缓存集市名称 
	static Transaction Sqlca =null;
	public String getConfigName() {
		return configName;
	}

	public void setConfigName(String configName) {
		this.configName = configName;
	}

	public String reloadCache() throws Exception{
		//定义变量
		String sReturn = "SUCCESS";
		if(configName.trim().length() > 0 ){
			try{
				CacheLoaderFactory.reload(configName);
			}catch(Exception e){
				ARE.getLog().error("同步数据库缓存失败："+e);
				sReturn = "FAILED";
			}
		}
		return sReturn;
	}
	
	public String reloadCacheAll() throws Exception{
		//定义变量
		
		String sReturn = "SUCCESS";
		try{
			CacheLoaderFactory.reloadAll();
		}catch(Exception e){
			e.printStackTrace();
			ARE.getLog().error("重载所有缓存失败："+e);
			sReturn = "FAILED";
		}
		/*
		Transaction sqlca = null;
		try{
			Configure CurConfig = Configure.getInstance();
			sqlca = new Transaction(CurConfig.getDataSource());
			String inSql = "DELETE from BAT_TASK_ERROR where ObjectType='reloadCache'";
			sqlca.executeSQL(inSql);
			sqlca.commit();
		}catch(Exception ex)
		{
			sqlca.disConnect();
			ex.printStackTrace();
			return "FAILED";
		}
		*/
		return "SUCCESS";
	}
}
