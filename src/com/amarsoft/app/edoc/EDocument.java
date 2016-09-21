/**
 * File Created 2008-1-14 下午02:40:52.
 */
package com.amarsoft.app.edoc;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;

import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import com.amarsoft.awe.util.Transaction;


/**
 * 电子文档类 实现了电子文档格式定义和电子文档数据定义 其中电子文档格式定义采用XML格式Office2003的Word文件格式
 * 
 * @author fmwu
 * 
 */
public class EDocument {

	private static SAXBuilder builder = new SAXBuilder();

	/**
	 * 电子文档格式定义Document
	 */
	private Document template = null;

	/**
	 * 电子文档数据定义Docmuent
	 */
	private Document datadef = null;
	private String templateFName = null;
	private String dataDefFName = null;

	/**
	 * 根据电子文档格式定义文件和电子文档数据定义文件实例化EDocument
	 * 
	 * @param fTemplateName
	 *            格式定义文件名
	 * @param fDataDefName
	 *            数据定义文件名
	 */
	public EDocument(String templateFName, String dataDefFName) throws JDOMException, IOException {
		this.templateFName = templateFName;
		template = builder.build(new File(templateFName));
		if (dataDefFName != null) {
			this.dataDefFName = dataDefFName;
			datadef = builder.build(new File(dataDefFName));
		}
	}

	/**
	 * 获取电子文档格式定义的标签列表
	 * 
	 * @param fname
	 *            电子文档格式定义文件名
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String getTagList(String fname) throws JDOMException, IOException {
		Document doc = builder.build(new File(fname));
		return ETagHandle.getTagList(doc);
	}

	/**
	 * 获取电子文档格式定义的标签列表
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public String getTagList() throws JDOMException, IOException {
		return ETagHandle.getTagList(template);
	}

	/**
	 * 获取电子文档数据定义的标签列表
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public String getDefTagList() throws JDOMException, IOException {
		return ETagHandle.getDefTagList(datadef);
	}

	/**
	 * 通过文档对象中的标签来检查data数据定义对象是否齐全
	 * 
	 * @param doc
	 *            文档对象
	 * @param data
	 *            数据对象
	 * @throws JDOMException
	 * @throws IOException
	 */
	public String checkTag() throws JDOMException, IOException {
		return ETagHandle.checkTag(template, datadef);
	}
	
	/**
	 * 用data数据对象替换文档对象中的标签
	 * 
	 * @param doc
	 *            文档对象
	 * @param data
	 *            数据对象
	 * @throws JDOMException
	 * @throws IOException
	 */
	private static void replaceTag(Document doc, Document data) throws JDOMException, IOException {
		// 替换单值标签
		ETagHandle.replaceSimpleTag(doc, data);
		// 首先替换表格数据标签
		ETagHandle.replaceTableTag(doc, data);
	}

	/**
	 * 输出根据数据定义缺省值生成的电子文档
	 * 
	 * @param fileName
	 *            输出文件名
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws JDOMException
	 */
	public String saveAsDefault(String fileName) throws FileNotFoundException, IOException, JDOMException {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8"); // 设置xml文件的字符集
		format.setIndent("   "); // 设置xml文件的缩进为4个空格

		XMLOutputter XMLOut = new XMLOutputter(format);// 在元素后换行，每一层元素缩排四格
		Document doc = builder.build(new File(templateFName));
		Document data = builder.build(new File(dataDefFName));
		replaceTag(doc, data);
		FileOutputStream fos = new FileOutputStream(fileName);
		XMLOut.output(doc, fos);
		if(fos != null){
			fos.close();
		}
		return fileName;
	}
	
	/**
	 * 输出根据数据定义缺省值生成的电子文档
	 * 
	 * @param fileName
	 *            输出文件名
	 * @return
	 * @throws Exception 
	 */
	public String saveDoc(String fileName,Map map,Transaction Sqlca) throws Exception {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8"); // 设置xml文件的字符集
		format.setIndent("   "); // 设置xml文件的缩进为4个空格

		XMLOutputter XMLOut = new XMLOutputter(format);// 在元素后换行，每一层元素缩排四格
		Document doc = builder.build(new File(templateFName));
		Document data = builder.build(new File(dataDefFName));
		data = EDataHandle.getData(data, map, Sqlca);
		replaceTag(doc, data);
		FileOutputStream fos = new FileOutputStream(fileName);
		XMLOut.output(doc, fos);
		if(fos != null){
			fos.close();
		}
		return fileName;
	}

	/**
	 * 输出根据数据定义缺省值生成的电子文档
	 * 
	 * @param fileName
	 *            输出文件名
	 * @return
	 * @throws Exception 
	 */
	public String saveData(String fileName,Map map,Transaction Sqlca) throws Exception {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8"); // 设置xml文件的字符集
		format.setIndent("   "); // 设置xml文件的缩进为4个空格

		XMLOutputter XMLOut = new XMLOutputter(format);// 在元素后换行，每一层元素缩排四格
		Document data = builder.build(new File(dataDefFName));
		data = EDataHandle.getData(data, map, Sqlca);
		FileOutputStream fos = new FileOutputStream(fileName);
		XMLOut.output(data, fos);
		if(fos != null){
			fos.close();
		}
		return fileName;
	}
	

}
