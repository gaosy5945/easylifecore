package com.amarsoft.app.als.sys.function.action;

import java.util.HashMap;

import com.amarsoft.app.als.sys.function.config.SysFunctionConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * 功能模块配置相关事件处理
 * @author amarsoft
 *
 */
public class SysFunctionHandler extends CommonHandler{

	/**
	 * 删除功能目录后，还要删除功能库信息
	 */
	public void afterDelete(JBOTransaction tx, BizObject bo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager(SysFunctionConst.JBONAME_SYS_FUN_LIB);
		tx.join(bm);
		bm.createQuery("Delete From O Where FunctionID=:FunctionID")
		  .setParameter("FunctionID", bo.getAttribute("FunctionID").toString())
		  .executeUpdate();
	}
	
	/**
	 * 如果FunctionID修改了，对用的功能库也要修改
	 */
	public void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception{
		HashMap<String, Object> oldValueMap = (HashMap<String, Object>)this.getOriginalValue(bo);
		for(String key : oldValueMap.keySet()){
			if("FunctionID".equalsIgnoreCase(key)){
				String oldValue = oldValueMap.get(key).toString();
				BizObjectManager bm = JBOFactory.getBizObjectManager(SysFunctionConst.JBONAME_SYS_FUN_LIB);
				tx.join(bm);
				bm.createQuery("update O Set FunctionID=:NewFunctionID Where FunctionID=:OldFunctionID")
				  .setParameter("NewFunctionID", bo.getAttribute("FunctionID").toString())
				  .setParameter("OldFunctionID", oldValue)
				  .executeUpdate();
			}
		}
	}
	
}
