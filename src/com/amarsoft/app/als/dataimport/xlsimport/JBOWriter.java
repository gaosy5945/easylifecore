package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.lang.DataElement;

/**
 * JBO����д����
 * @author syang
 * @date 2011/08/18
 *
 */
public abstract class JBOWriter {
	private BizObjectClass targetBizObjectClass = null;		//д��Ŀ��JBO��
	private BizObjectManager manager = null;
	protected List<ExcelImportInterceptor> interceptors = new ArrayList<ExcelImportInterceptor>(1);
	
	/**
	 * ����һ��д����
	 * @param manager
	 * @param targetBizObject
	 */
	public JBOWriter(BizObjectManager manager,BizObjectClass clazz) {
		this.targetBizObjectClass = clazz;
		this.manager = manager;
	}
	/**
	 * ��ȡд���Ŀ��JBO��
	 * @return
	 */
	public BizObjectClass getTargetBizObjectClass() {
		return targetBizObjectClass;
	}
	/**
	 * ����д���Ŀ��JBO��
	 * @param targetBizObject
	 */
	public void setTargetBizObject(BizObjectClass clazz) {
		this.targetBizObjectClass = clazz;
	}
	/***
	 * ��ȡJBO Manager
	 * @return
	 */
	public BizObjectManager getManager(){
		return manager;
	}
	
	public List<ExcelImportInterceptor> getInterceptors() {
		return interceptors;
	}
	public void setInterceptors(List<ExcelImportInterceptor> interceptors) {
		this.interceptors = interceptors;
	}
	/**
	 * ��map������д��
	 * @param dataMap excel����
	 * @throws WriteException
	 */
	public abstract void write(Map<String,DataElement> dataMap) throws WriteException;

	
}
