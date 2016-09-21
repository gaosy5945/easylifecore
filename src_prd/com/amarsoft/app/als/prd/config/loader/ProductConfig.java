package com.amarsoft.app.als.prd.config.loader;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class ProductConfig extends AbstractCache{

	public static final String SYS_FUNCTION_MODULE = "ALS_PRODUCT";
	public static final String PRODUCT_CONFIG_VIEW_CATALOG = "jbo.prd.PRD_VIEW_CATALOG";
	public static final String PRODUCT_CONFIG_VIEW = "jbo.prd.PRD_VIEW_LIBRARY";
	public static final String PRODUCT_CONFIG_PRODUCT = "jbo.prd.PRD_PRODUCT_LIBRARY";	
	public static final String PRODUCT_CONFIG_PRODUCT_RELATIVE = "jbo.prd.PRD_PRODUCT_RELATIVE";	
	public static final String PRODUCT_CONFIG_SPECIFICATION = "jbo.prd.PRD_SPECIFIC_LIBRARY";
	public static final String PRODUCT_CONFIG_TRANSACTION_RELATIVE = "jbo.prd.PRD_TRANSACTION_RELATIVE";
	
	public static final String PRODUCT_TYPE_BASIC_PRODUCT="01";
	public static final String PRODUCT_TYPE_PROJECT_PRODUCT="02";
	public static final String PRODUCT_CATALOG_DEFAULT="Standard";
	
	public static final String PRODUCT_COMPONENT_TYPE_CODENO = "PrdComponentType";
	public static final String DEFAULT_SPECIFICID = "000";
	public static final String PRODUCT_TRANSACTION_JBOCLASS = "jbo.prd.PRD_TRANSACTION";
	
	public static final String PRODUCT_TRANSACTION_STATUS_New="0";
	public static final String PRODUCT_TRANSACTION_STATUS_Process="3";
	public static final String PRODUCT_TRANSACTION_STATUS_Approved="4";
	public static final String PRODUCT_TRANSACTION_STATUS_Finish="1";
	public static final String PRODUCT_TRANSACTION_STATUS_Closed="2";
	
	private static BusinessObjectCache productCache = null;
    
	public void clear() throws Exception {
		productCache.clear();
	}
	
	public synchronized boolean load(Transaction transaction) throws Exception {
		productCache=new BusinessObjectCache(500);
		return true;
	}
	
	/**
	 * 获取产品定义
	 * @param productID
	 * @return
	 * @throws Exception
	 */
	public synchronized static BusinessObject getProduct(String productID) throws Exception{
		String cacheKey="ProductID="+productID;
		BusinessObject product = (BusinessObject)productCache.getCacheObject(cacheKey);
		if(product==null){
			BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
			product = BusinessObjectFactory.loadSingle(ProductConfig.PRODUCT_CONFIG_PRODUCT, productID, bomanager);
			if(product==null){
				throw new ALSException("EC5001",productID);
			}
			productCache.setCache(cacheKey, product);
		}
		
    	return product;
	}
	
	/**
	 * 获取规格号下的最新版本定义
	 * @param productID
	 * @param specificID
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getSpecific(String productID,String prjProductID) throws Exception{
		return getSpecific(productID,prjProductID,ProductConfig.DEFAULT_SPECIFICID);
	}
	
	/**
	 * 获取规格号下的最新版本定义
	 * @param productID
	 * @param specificID
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getSpecific(String productID,String prjProductID,String specificID) throws Exception{
		if(StringX.isEmpty(prjProductID))prjProductID=productID;
		if(StringX.isEmpty(specificID))specificID=ProductConfig.DEFAULT_SPECIFICID;
		BusinessObject validSpecific=null;
		BusinessObject product=getProduct(prjProductID);
		List<BusinessObject> specificList = product.getBusinessObjects(ProductConfig.PRODUCT_CONFIG_SPECIFICATION);
		for(BusinessObject specific:specificList){
			if(!specificID.equals(specific.getString("SpecificID"))) continue;
			if(!"1".equals(specific.getString("Status"))) continue;
			if(!productID.equals(specific.getString("ProductID"))) continue;
			validSpecific= specific;
		}
		if(validSpecific==null){
			throw new ALSException("EC5002",prjProductID,specificID);
		}
		return validSpecific;
	}
}