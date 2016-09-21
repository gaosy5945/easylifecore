package com.amarsoft.app.als.sys.tools;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;



/**
 * JBO Hepler Tool Class  
 * @author ycliu2
 * @version ALS75
 */
public class ToolBox {
	
	/**
	 * 将对象中的属性名称和值转换成Map<name,value>
	 * @parta
	 */
	public static Map<String , Object> getContext(Object object){
		return getContext(object , false);
	}
	
	/**
	 * 将对象中的属性名称和值转换成Map<name,value>
	 * 可选择是否查找父类中的属性，暂时只支持向上查找一层
	 */
	public static Map<String , Object> getContext(Object object ,Boolean needSuperClassContext){
		if("BizObject".equalsIgnoreCase(object.getClass().getSuperclass().getSimpleName()) ||
				"BizObject".equalsIgnoreCase(object.getClass().getSimpleName())){
			return 	getBizObjectContext((BizObject)object);
		}
		else{
			try {
				return getObjectContext(object,needSuperClassContext);
			} catch (Exception e) {
				e.printStackTrace();
			} 
			return new HashMap<String , Object>();
		}
	}
	
	
	/**
	 * 讲Map中的数据填充至对象中
	 * @param object
	 * @param map
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Object fillObject(Object object , Map map,boolean needSuperClassContext,String... exceptParaName){
		fillObject(object, map, object.getClass(), exceptParaName);
		//填充父类的信息
		if(needSuperClassContext)
			fillObject(object, map, object.getClass().getSuperclass(), exceptParaName);		
		return object;
	}
	
	/**
	 * 讲Map中的数据填充至对象中
	 * @param object
	 * @param map
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Object fillFatherObject(Object object , Map map,String... exceptParaName){
		//填充父类的信息
		fillObject(object, map, object.getClass().getSuperclass(), exceptParaName);		
		return object;
	}
	
	/**
	 * 讲Map中的数据填充至对象中
	 * @param object
	 * @param map
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	private static Object fillObject(Object object , Map map, Class myClass ,String[] exceptParaName){
		Set keys = map.keySet();
		Field[] fields =myClass.getDeclaredFields();
		if(exceptParaName.length != 0)
			fields = fileterName(fields, exceptParaName);
		try {
			for(Field f : fields){
				f.setAccessible(true); 
				for(Iterator it = keys.iterator() ; it.hasNext();){
					String s = it.next().toString();
					if(s.equalsIgnoreCase(f.getName())){
						f.set(object, f.getType().cast(map.get(s)));
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return object;
	}
	
	
	//过滤不想填充的对象的域
	private static Field[] fileterName(Field[] fields , String[] name){
		List<Field> result = new ArrayList<Field>();
		/*for(String s : name){
			for(Field f : fields){
				String temp = f.getType().toString();
				temp = temp.substring(temp.lastIndexOf(".")+1, temp.length());
				if(s.equalsIgnoreCase(temp.toUpperCase()))
					break;
				result.add(f);
			}
		}*/

		Begin:for(Field f : fields){
						for(String s : name){
							String temp = f.getType().toString();
							temp = temp.substring(temp.lastIndexOf(".")+1, temp.length());
							if(temp.contains(";"))
								temp = temp.substring(0,temp.length() - 1);
							if(s.equalsIgnoreCase(temp.toUpperCase()))
								continue Begin;
						}
						result.add(f);
					}
		
		Field[] fs = new Field[result.size()];
		return result.toArray(fs);
	}
	
			
	/**
	 * 获取对象的内容
	 * @throws IllegalAccessException 
	 * @throws IllegalArgumentException 
	 * @return Map<String ,String>  constains Object context as <name ,value>
	 */
	private static Map<String , Object> getObjectContext(Object object , boolean needSuperClassContext) throws IllegalArgumentException, IllegalAccessException{
		Map<String , Object> map = new HashMap<String , Object>();
		Field[] fields = object.getClass().getDeclaredFields();
		for(Field f : fields){
			f.setAccessible(true);
			map.put(f.getName(), f.get(object));
		}
		if(needSuperClassContext){
			fields = (object.getClass().getSuperclass()).getDeclaredFields();
			for(Field f : fields){
				f.setAccessible(true);
				map.put(f.getName(), f.get(object));
			}
		}
		return map;
	}
	
	/**
	 * @param bizObject
	 * @return Map<String ,String>  constains BizObject context as <name ,value>
	 */
		private static  Map<String ,Object> getBizObjectContext(BizObject bizObject){
			Map<String , Object> map = new HashMap<String , Object>();
			for(int i = 0 ; i < bizObject.getAttributeNumber() ; i++){
				try {
					map.put(bizObject.getAttribute(i).getName(), bizObject.getAttribute(i).toString());
				} catch (JBOException e) {
					e.printStackTrace();
				}
			}			
			return map;
		}
		
		/**讲JBO读取出的BOLB显示乱码信息还原
		 * @param s
		 * @return
		 */
		public static  String  convertBlon(String s) {
			if(s == null || "".equals(s))
				return "";
			byte[] ss = new byte[s.length()/2];
			char[] chars = s.toCharArray();
			try{
				if(chars.length %2 != 0){
					throw new RuntimeException("Blob数据读取有误");
				}			
			}catch (Exception e) {
				e.printStackTrace();
			}
			int j = 0;
			for(int i = 0; i < chars.length;i++){
				char firts = chars[i];
				char las = chars[++i];
				ss[j++] = (byte) (convertChar(firts)*16 + convertChar(las));
			}
			try {
				return new String(ss,ARE.getProperty("CharSet","GBK"));
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			};		
			return "";
		}
		//将16进制字符串转化为10进制数据。
		private static int convertChar(char c){
			switch(c){
				case '1':
					return 1;
				case '2':
					return 2;
				case '3':
					return 3;
				case '4':
					return 4;
				case '5':
					return 5;
				case '6':
					return 6;
				case '7':
					return 7;
				case '8':
					return 8;
				case '9':
					return 9;
				case 'a':
					return 10;
				case 'b':
					return 11;
				case 'c':
					return 12;
				case 'd':
					return 13;
				case 'e':
					return 14;
				case 'f':
					return 15;
			}
			return 0;
		}
		
		
		
		/**
		 * 将Map中的数据填充值BizObject中
		 * @param map
		 * @param bo
		 * @return
		 * @throws JBOException
		 */
		@SuppressWarnings("rawtypes")
		public static BizObject mapToBiz(Map map ,BizObject bo) throws JBOException{
			DataElement[] list = bo.getAttributes();
			for(DataElement d : list){
				String name = d.getName();
				String value = map.get(name) == null ?  "" : map.get(name) .toString();
				bo.setAttributeValue(name, value);
			}
			return bo;
		}
}
