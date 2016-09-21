package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * Excel���ݵ���������
 * @author ls0478
 *
 */
public interface ExcelImportInterceptor{
	public void setTransaction(JBOTransaction tx) throws JBOException;
	public JBOTransaction getJBOTransaction();
	/**
	 * ��ȡ����֮ǰִ��
	 * @param tx
	 */
	public void beforeRead(int rowNumber) throws Exception;
	/**
	 * ��ȡ������ɺ�ִ��
	 * @param tx
	 * @param rowItem
	 */
	public void afterRead(int rowNumber,Map<String,DataElement> rowItem) throws Exception;
	/**
	 * д������ǰִ��
	 * @param tx
	 * @param rowItem
	 */
	public void beforeWrite(BizObject rowItem) throws Exception;
	/**
	 * д�����ݺ�ִ��
	 * @param tx
	 * @param rowItem
	 */
	public void afterWrite(BizObject rowItem) throws Exception;
}
