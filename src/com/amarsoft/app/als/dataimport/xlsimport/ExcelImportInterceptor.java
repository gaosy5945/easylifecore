package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

/**
 * Excel数据导入拦截器
 * @author ls0478
 *
 */
public interface ExcelImportInterceptor{
	public void setTransaction(JBOTransaction tx) throws JBOException;
	public JBOTransaction getJBOTransaction();
	/**
	 * 读取数据之前执行
	 * @param tx
	 */
	public void beforeRead(int rowNumber) throws Exception;
	/**
	 * 读取数据完成后，执行
	 * @param tx
	 * @param rowItem
	 */
	public void afterRead(int rowNumber,Map<String,DataElement> rowItem) throws Exception;
	/**
	 * 写入数据前执行
	 * @param tx
	 * @param rowItem
	 */
	public void beforeWrite(BizObject rowItem) throws Exception;
	/**
	 * 写入数据后执行
	 * @param tx
	 * @param rowItem
	 */
	public void afterWrite(BizObject rowItem) throws Exception;
}
