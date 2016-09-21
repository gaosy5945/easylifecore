package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.lang.DataElement;

/**
 * JBO数据写入类
 * @author syang
 * @date 2011/08/18
 *
 */
public abstract class JBOWriter {
	private BizObjectClass targetBizObjectClass = null;		//写入目标JBO类
	private BizObjectManager manager = null;
	protected List<ExcelImportInterceptor> interceptors = new ArrayList<ExcelImportInterceptor>(1);
	
	/**
	 * 构造一个写入器
	 * @param manager
	 * @param targetBizObject
	 */
	public JBOWriter(BizObjectManager manager,BizObjectClass clazz) {
		this.targetBizObjectClass = clazz;
		this.manager = manager;
	}
	/**
	 * 获取写入的目标JBO类
	 * @return
	 */
	public BizObjectClass getTargetBizObjectClass() {
		return targetBizObjectClass;
	}
	/**
	 * 设置写入的目标JBO类
	 * @param targetBizObject
	 */
	public void setTargetBizObject(BizObjectClass clazz) {
		this.targetBizObjectClass = clazz;
	}
	/***
	 * 获取JBO Manager
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
	 * 把map中数据写入
	 * @param dataMap excel数据
	 * @throws WriteException
	 */
	public abstract void write(Map<String,DataElement> dataMap) throws WriteException;

	
}
