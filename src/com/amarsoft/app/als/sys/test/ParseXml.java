package com.amarsoft.app.als.sys.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Iterator;

import com.amarsoft.are.AREException;
import com.amarsoft.are.util.conf.Attributes;
import com.amarsoft.are.util.conf.Configuration;
import com.amarsoft.are.util.conf.Node;

/**解析jboxml
 * @author amarbdserver
 *
 */
public class ParseXml {

	/**
	 * @param args
	 * @throws AREException 
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException, AREException {
		File file=new File("/home/cjyu/software/workspace/ALS744/WebContent/WEB-INF/etc/jbo");
		File[]  files=file.listFiles();
		for(File f:files){
			String fileName=f.getAbsolutePath();
			if(!fileName.endsWith("jbomanagers.xml")&& f.getName().startsWith("jbo") )	parse(f.getAbsolutePath());
		}
	}
	
	public static void parse(String filePath) throws FileNotFoundException, AREException{
		//COMMENT ON COLUMN ALS6.USER_INFO.USERID IS '用户编号';
		String schema = "";
		//String path = "D:\\workspace\\CDP\\WebContent\\WEB-INF\\etc\\jbo\\jbo_app.xml";
		File file = new File(filePath);
		InputStream in = new FileInputStream(file);
		//解析xml
		Configuration conf = new Configuration();
		conf.loadFromStream(in);
		Node node = conf.getRootNode();
		Iterator<Node> it = node.getChild("package").getChildren("class").iterator();
		Node classNode = null;
		Node filedNode = null;
		String tableName = "";
		Iterator<Node> itFiled;		
		String filed = "";
		String filedLable = "";
		int i = 0;
		StringBuffer sb = new StringBuffer();
		while(it.hasNext()){
			i++;
			classNode = it.next();
			Attributes attr = classNode.getAttributes();
			tableName = attr.getAttribute("name").toString();
			//tableName = classNode.getName();//表名
			itFiled = classNode.getChild("attributes").getChildren("attribute").iterator();
			while(itFiled.hasNext()){
				filedNode = itFiled.next();
				Attributes attrFiled = filedNode.getAttributes();
				filed = attrFiled.getAttribute("name").toString();
				filedLable = attrFiled.getAttribute("label").toString();
				sb.append(" COMMENT ON COLUMN ").append(schema).append(""+tableName+".").append(""+filed+"").append(" IS '"+filedLable+"';\n "); //("USER_INFO.USERID IS '用户编号'; ");
			}
		}
		
	}

}
