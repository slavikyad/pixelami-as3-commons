package org.pixelami.amf
{	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;
	
	import org.flexunit.asserts.assertEquals;
	import org.pixelami.amf.mock.SomeClass;
	import org.pixelami.amf.mock.SomeItem;
	import org.pixelami.util.Printer;

	public class AMFDecoderTest
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testDecodeString():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject("hello world !");
			ba.position = 0;
			var decoder:AMFDecoder = new AMFDecoder(ba);
			var result:Object = decoder.readValue();
			//trace("result",result);
			assertEquals("hello world !",result)
		}
		
		[Test]
		public function testDecodeArray():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(["hello world !","another"]);
			ba.position = 0;
			var decoder:AMFDecoder = new AMFDecoder(ba);
			var result:Object = decoder.readValue();
			//trace("result",result);
			assertEquals(2,(result as Array).length);
		}
		
		[Test]
		public function testDecodeArrayWithMultipleTypes():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject(["hello world !",1,null,3.12,false]);
			ba.position = 0;
			var decoder:AMFDecoder = new AMFDecoder(ba);
			var result:Object = decoder.readValue();
			//trace("result",result);
			assertEquals(5,(result as Array).length);
		}
		
		[Test]
		public function testDecodeObject():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject({label:"foo",value:"bar"});
			ba.position = 0;
			var decoder:AMFDecoder = new AMFDecoder(ba);
			var result:Object = decoder.readValue();
			trace("result",ObjectUtil.toString(result));
			assertEquals(result.label,"foo");
			assertEquals(result.value,"bar");
		}
		
		
		[Test]
		public function testDecodeTypedObject():void
		{
			var ba:ByteArray = new ByteArray();
			var so:SomeClass = new SomeClass();
			registerClassAlias(getQualifiedClassName(so),SomeClass);
			so.property1 = "foo";
			so.property2 = "bar";
			ba.writeObject(so);
			ba.position = 0;
			var decoder:AMFDecoder = new AMFDecoder(ba);
			var result:Object = decoder.readValue();
			//trace("result",ObjectUtil.toString(result));
			assertEquals(result.property1,"foo");
			assertEquals(result.property2,"bar");
		}
		
		
		[Test]
		public function testDecodeTypedObjectWithArrayItems():void
		{
			var ba:ByteArray = new ByteArray();
			var so:SomeClass = new SomeClass();
			registerClassAlias(getQualifiedClassName(SomeClass),SomeClass);
			registerClassAlias(getQualifiedClassName(SomeItem),SomeItem);
			so.property1 = "foo";
			so.property2 = "bar";
			so.arrayProperty = [new SomeItem("foo",1),new SomeItem("bar",2)];
			
			ba.writeObject(so);
			ba.position = 0;
			Printer.printBits(ba);
			ba.position = 0;
			var decoder:AMFDecoder = new AMFDecoder(ba);
			var result:Object = decoder.readValue();
			//trace("result",ObjectUtil.toString(result));
			assertEquals(result.property1,"foo");
			assertEquals(result.property2,"bar");
			assertEquals(2,result.arrayProperty.length);
			var item:Object = result.arrayProperty[0];
			assertEquals("foo",item.label);
		}


	}
}