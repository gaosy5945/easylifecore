package com.amarsoft.app.als.cl;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;


/**
 * Class <code>CreditLineObject</code>是额度对象的基础接口. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public abstract class CreditLineObject extends CreditObject {
	/**
	 * 用于保存额度对象关联的拆分信息（子CL_INFO）
	 */
	protected List<BusinessObject> splitObjects=null;
	/**
	 * 用于保存额度可用授信金额
	 */
	public double doSum = 0.0;
	/**
	 * 保存单笔授信贷款余额占用上层额度余额
	 */
	protected double useBalance = 0.0d;
	
	/**
	 * 保存单笔授信贷款金额占用上层额度金额
	 */
	protected double useSum = 0.0d;
	
	/**
	 *@param BusinessObject 通过外部传入不通过数据库连接初始化
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject) throws SQLException,Exception{
		this.CreditObject = creditObject;
	}
	
	/**
	 *@param BusinessObject 通过外部传入不通过数据库连接初始化
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject,List<BusinessObject> splitObjects) throws SQLException,Exception{
		if(creditObject!=null) load(creditObject);
		if(splitObjects!=null) this.splitObjects = splitObjects;
	}
	
}
