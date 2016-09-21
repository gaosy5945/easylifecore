package com.amarsoft.app.base.config.impl;
/**
 * @author ckxu
 * 描述：处理商品的配置 ,在这个方法中，使用了中文的匹配，需要进一步的进行完善
 * */
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
public class MerchandiseConfig extends XMLConfig{
	private static final String MERCHANDISE_BRAND = "merchandiseBrand";
	private static BusinessObjectCache merchandiseConfigs=new BusinessObjectCache(1000);
	
	//单例模式
	private static MerchandiseConfig mc = null;
	
	private MerchandiseConfig(){
		
	}
	
	public static MerchandiseConfig getInstance(){
		if(mc == null)
			mc = new MerchandiseConfig();
		return mc;
	}
	
	//根据商品的品牌名称,获取商品品牌ID
	public static String getMerchandiseBrand(String brandName) throws Exception{
		if(StringX.isEmpty(brandName)) 
			return "";
		Map<String, Object> map = merchandiseConfigs.getCacheObjects();
		for(String key:map.keySet()){
			BusinessObject bo = (BusinessObject)map.get(key);
			if(brandName.trim().equalsIgnoreCase(bo.getString("NAME").trim())){
				return key;
			}
		}
		return "";
	}
	/*
	 * 品牌的id和商品的型号中文，获取对应的配置文件中的商品的型号
	 * */
	public static String getBrandModel(String brand,String brandModelName) throws Exception{
		if(StringX.isEmpty(brand)||StringX.isEmpty(brandModelName)) 
			return "";
		Map<String, Object> map = merchandiseConfigs.getCacheObjects();
		for(String key:map.keySet()){
			if(key.equals(brand)){
				BusinessObject boBrand = (BusinessObject)map.get(brand);
				List<BusinessObject> list = boBrand.getBusinessObjects("merchandise");
				for(BusinessObject bo:list){
					if(brandModelName.trim().replaceAll(" ", "").equalsIgnoreCase(bo.getString("NAME").trim().replaceAll(" ", ""))){
						return bo.getString("ID");
					}
				}
			}
		}
		return"";
	}
	/*
	 * 品牌的id和商品的型号中文，获取对应的配置文件中的商品的型号
	 * */
	public static String getBrandModelName(String brandModel) throws Exception{
		if(StringX.isEmpty(brandModel)) 
			return "";
		Map<String, Object> map = merchandiseConfigs.getCacheObjects();
		for(String key:map.keySet()){
			String brand = brandModel.split("-")[0];
			if(key.equals(brand)){//获取品牌的所有的数据
				BusinessObject boBrand = (BusinessObject)map.get(brand);
				List<BusinessObject> list = boBrand.getBusinessObjects("merchandise");
				for(BusinessObject bo:list){
					if(brandModel.trim().equalsIgnoreCase(bo.getString("ID").trim())){
						return bo.getString("NAME");
					}
				}
			}
		}
		return"";
	}
	/*
	 * 根据商品的品牌代码获取品牌名称
	 * */
	public static String getMerchandiseBrandName(String brand) throws Exception{
		if(StringX.isEmpty(brand)) 
			return "";
		Map<String, Object> map = merchandiseConfigs.getCacheObjects();
		for(String key:map.keySet()){
			if(key.trim().equalsIgnoreCase(brand.trim())){
				BusinessObject bo = (BusinessObject)map.get(key);
				return bo.getString("NAME");
			}
		}
		return "";
	}
	
	@Override
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		Document document = getDocument(file);
		Element root = document.getRootElement();
		BusinessObjectCache merchandiseConfigs = new BusinessObjectCache(size);
		
		@SuppressWarnings("unchecked")
		List<BusinessObject> merchandiseList = this.convertToBusinessObjectList(root.getChildren(MERCHANDISE_BRAND));
		if (merchandiseList!=null) {
			for (BusinessObject merchandise : merchandiseList) {
				merchandiseConfigs.setCache(merchandise.getString("ID"), merchandise);
			}
		}
		MerchandiseConfig.merchandiseConfigs = merchandiseConfigs;
	}
}
