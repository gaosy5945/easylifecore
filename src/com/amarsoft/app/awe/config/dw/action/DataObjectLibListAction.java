package com.amarsoft.app.awe.config.dw.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * DataWindowģ����б�����
 *
 */
public class DataObjectLibListAction {
	private String DONO;
	private String colIndex;

	/**
	 * ����
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	public String quickCopyLib(JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.awe.DATAOBJECT_LIBRARY");
		tx.join(m);
		BizObject lib = m.createQuery("DONO = :DONO and ColIndex = :ColIndex").setParameter("DONO", DONO).setParameter("ColIndex", colIndex).getSingleResult(false);
		
		String colindex_copy = colIndex +"_copy";
		BizObject newLib = m.newObject();
		newLib.setAttributesValue(lib);
		newLib.setAttributeValue("ColIndex", colindex_copy);
		m.saveObject(newLib);
		return "SUCCESS";
	}
	
	/**
	 * ��ȡģ����
	 * @return
	 */
	public String getDONO() {
		return DONO;
	}

	public void setDONO(String dONO) {
		DONO = dONO;
	}

	/**
	 * ��ȡ�����
	 * @return
	 */
	public String getColIndex() {
		return colIndex;
	}

	public void setColIndex(String colIndex) {
		this.colIndex = colIndex;
	}
}