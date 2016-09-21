package com.amarsoft.app.als.sys.function.action;

import java.util.HashMap;

import com.amarsoft.app.als.sys.function.config.SysFunctionConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
/**
 * ����ģ����������¼�����
 * @author amarsoft
 *
 */
public class SysFunctionHandler extends CommonHandler{

	/**
	 * ɾ������Ŀ¼�󣬻�Ҫɾ�����ܿ���Ϣ
	 */
	public void afterDelete(JBOTransaction tx, BizObject bo) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager(SysFunctionConst.JBONAME_SYS_FUN_LIB);
		tx.join(bm);
		bm.createQuery("Delete From O Where FunctionID=:FunctionID")
		  .setParameter("FunctionID", bo.getAttribute("FunctionID").toString())
		  .executeUpdate();
	}
	
	/**
	 * ���FunctionID�޸��ˣ����õĹ��ܿ�ҲҪ�޸�
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
