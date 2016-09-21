/**
 * File Created 2008-1-14 ����02:40:52.
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
 * �����ĵ��� ʵ���˵����ĵ���ʽ����͵����ĵ����ݶ��� ���е����ĵ���ʽ�������XML��ʽOffice2003��Word�ļ���ʽ
 * 
 * @author fmwu
 * 
 */
public class EDocument {

	private static SAXBuilder builder = new SAXBuilder();

	/**
	 * �����ĵ���ʽ����Document
	 */
	private Document template = null;

	/**
	 * �����ĵ����ݶ���Docmuent
	 */
	private Document datadef = null;
	private String templateFName = null;
	private String dataDefFName = null;

	/**
	 * ���ݵ����ĵ���ʽ�����ļ��͵����ĵ����ݶ����ļ�ʵ����EDocument
	 * 
	 * @param fTemplateName
	 *            ��ʽ�����ļ���
	 * @param fDataDefName
	 *            ���ݶ����ļ���
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
	 * ��ȡ�����ĵ���ʽ����ı�ǩ�б�
	 * 
	 * @param fname
	 *            �����ĵ���ʽ�����ļ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String getTagList(String fname) throws JDOMException, IOException {
		Document doc = builder.build(new File(fname));
		return ETagHandle.getTagList(doc);
	}

	/**
	 * ��ȡ�����ĵ���ʽ����ı�ǩ�б�
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public String getTagList() throws JDOMException, IOException {
		return ETagHandle.getTagList(template);
	}

	/**
	 * ��ȡ�����ĵ����ݶ���ı�ǩ�б�
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public String getDefTagList() throws JDOMException, IOException {
		return ETagHandle.getDefTagList(datadef);
	}

	/**
	 * ͨ���ĵ������еı�ǩ�����data���ݶ�������Ƿ���ȫ
	 * 
	 * @param doc
	 *            �ĵ�����
	 * @param data
	 *            ���ݶ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	public String checkTag() throws JDOMException, IOException {
		return ETagHandle.checkTag(template, datadef);
	}
	
	/**
	 * ��data���ݶ����滻�ĵ������еı�ǩ
	 * 
	 * @param doc
	 *            �ĵ�����
	 * @param data
	 *            ���ݶ���
	 * @throws JDOMException
	 * @throws IOException
	 */
	private static void replaceTag(Document doc, Document data) throws JDOMException, IOException {
		// �滻��ֵ��ǩ
		ETagHandle.replaceSimpleTag(doc, data);
		// �����滻������ݱ�ǩ
		ETagHandle.replaceTableTag(doc, data);
	}

	/**
	 * ����������ݶ���ȱʡֵ���ɵĵ����ĵ�
	 * 
	 * @param fileName
	 *            ����ļ���
	 * @return
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws JDOMException
	 */
	public String saveAsDefault(String fileName) throws FileNotFoundException, IOException, JDOMException {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8"); // ����xml�ļ����ַ���
		format.setIndent("   "); // ����xml�ļ�������Ϊ4���ո�

		XMLOutputter XMLOut = new XMLOutputter(format);// ��Ԫ�غ��У�ÿһ��Ԫ�������ĸ�
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
	 * ����������ݶ���ȱʡֵ���ɵĵ����ĵ�
	 * 
	 * @param fileName
	 *            ����ļ���
	 * @return
	 * @throws Exception 
	 */
	public String saveDoc(String fileName,Map map,Transaction Sqlca) throws Exception {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8"); // ����xml�ļ����ַ���
		format.setIndent("   "); // ����xml�ļ�������Ϊ4���ո�

		XMLOutputter XMLOut = new XMLOutputter(format);// ��Ԫ�غ��У�ÿһ��Ԫ�������ĸ�
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
	 * ����������ݶ���ȱʡֵ���ɵĵ����ĵ�
	 * 
	 * @param fileName
	 *            ����ļ���
	 * @return
	 * @throws Exception 
	 */
	public String saveData(String fileName,Map map,Transaction Sqlca) throws Exception {
		Format format = Format.getCompactFormat();
		format.setEncoding("UTF-8"); // ����xml�ļ����ַ���
		format.setIndent("   "); // ����xml�ļ�������Ϊ4���ո�

		XMLOutputter XMLOut = new XMLOutputter(format);// ��Ԫ�غ��У�ÿһ��Ԫ�������ĸ�
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
