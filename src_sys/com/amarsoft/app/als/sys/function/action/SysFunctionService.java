package com.amarsoft.app.als.sys.function.action;

import java.util.List;

import com.amarsoft.app.als.sys.function.config.SysFunctionConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class SysFunctionService {
	String functionID;	//功能号
	BizObjectManager catbm;
	BizObjectManager libbm;
	/**
	 * 复制功能配置
	 * @param tx
	 * @return
	 * @throws JBOException 
	 */
	public String copyFunctionConfig(JBOTransaction tx) throws JBOException{
		init(tx);
		boolean result = copyFunctionCatalog();
		if (result){
			copyFunctionLibrary();
			return "true";
		}
		
		return "false";
	}
	
	public String updateFunctionConfig(JBOTransaction tx){
		return "";
	}
	
	/**
	 * 复制功能目录，FunctionID前缀+"CopyOf"
	 * @return
	 * @throws JBOException
	 */
	public boolean copyFunctionCatalog() throws JBOException{
		BizObject bo = catbm.createQuery("FunctionID=:FunctionID")
				.setParameter("FunctionID", functionID)
				.getSingleResult(false);
		//判断是否已存在复制项
		BizObject boX = catbm.createQuery("FunctionID=:FunctionID")
				.setParameter("FunctionID", SysFunctionConst.COPY_FLAG + functionID)
				.getSingleResult(false);
		if (boX == null) {
			BizObject newBo = catbm.newObject();
			newBo.setAttributesValue(bo);
			newBo.setAttributeValue("FunctionID", SysFunctionConst.COPY_FLAG + functionID);
			catbm.saveObject(newBo);
			return true;
		}
		
		return false;
	}
	
	/**
	 * 复制功能库，FunctionID前缀+"CopyOf"
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	public void copyFunctionLibrary() throws JBOException{
		List<BizObject> bolist = libbm.createQuery("FunctionID=:FunctionID")
				.setParameter("FunctionID", functionID)
				.getResultList(false);
		for(BizObject bo : bolist){
			BizObject newBo = libbm.newObject();
			newBo.setAttributesValue(bo);
			//自动生成流水号
			newBo.setAttributeValue("SerialNo", "");
			newBo.setAttributeValue("FunctionID", SysFunctionConst.COPY_FLAG + functionID);
			libbm.saveObject(newBo);
		}
	}
	
	/**
	 * 初始化BizObjectManager
	 * @param tx
	 * @throws JBOException
	 */
	private void init(JBOTransaction tx) throws JBOException{
		this.catbm = JBOFactory.getBizObjectManager(SysFunctionConst.JBONAME_SYS_FUN_CAT);
		this.libbm = JBOFactory.getBizObjectManager(SysFunctionConst.JBONAME_SYS_FUN_LIB);
		tx.join(catbm);
		tx.join(libbm);
	}
	
	public String getFunctionID() {
		return functionID;
	}
	
	public void setFunctionID(String functionID) {
		this.functionID = functionID;
	}
}
