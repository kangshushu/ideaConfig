
˚
squid:S2225Î
squidS22259"toString()" and "clone()" methods should not return null"MAJOR*java:ç<p>Calling <code>toString()</code> or <code>clone()</code> on an object should always return a string or an object. Returning <code>null</code>
instead contravenes the method's implicit contract.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public String toString () {
  if (this.collection.isEmpty()) {
    return null; // Noncompliant
  } else {
    // ...
 {code}
</pre>
<h2>Compliant Solution</h2>
<pre>
public String toString () {
  if (this.collection.isEmpty()) {
    return "";
  } else {
    // ...
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/476.html">MITRE CWE-476</a> - NULL Pointer Dereference </li>
</ul>ZBUG
ß
squid:S3688ó
squidS3688 Track uses of disallowed classes"INFO*java: <p>This rule allows banning certain classes.</p>
<h2>Noncompliant Code Example</h2>
<p>Given parameters:</p>
<ul>
  <li> className:java.lang.String </li>
</ul>
<pre>
String name;  // Noncompliant
</pre>@Z
CODE_SMELL
•
squid:S00105î
squidS00105(Tabulation characters should not be used"MINOR*java2S105:π<p>Developers should not need to configure the tab width of their text editors in order to be able to read source code.</p>
<p>So the use of the tabulation character must be banned.</p>Z
CODE_SMELL
ø
squid:S2445Ø
squidS2445EBlocks should be synchronized on "private final" fields or parameters"MAJOR*java:≈<p>Synchronizing on a class field synchronizes not on the field itself, but on the object assigned to it. So synchronizing on a non-<code>final</code>
field makes it possible for the field's value to change while a thread is in a block synchronized on the old value. That would allow a second thread,
synchronized on the new value, to enter the block at the same time.</p>
<p>The story is very similar for synchronizing on parameters; two different threads running the method in parallel could pass two different object
instances in to the method as parameters, completely undermining the synchronization.</p>
<h2>Noncompliant Code Example</h2>
<pre>
private String color = "red";

private void doSomething(){
  synchronized(color) {  // Noncompliant; lock is actually on object instance "red" referred to by the color variable
    //...
    color = "green"; // other threads now allowed into this block
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
private String color = "red";
private final Object lockObj = new Object();

private void doSomething(){
  synchronized(lockObj) {
    //...
    color = "green";
    // ...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/412.html">MITRE, CWE-412</a> - Unrestricted Externally Accessible Lock </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/413">MITRE, CWE-413</a> - Improper Resource Locking </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/6IEzAg">CERT, LCK00-J.</a> - Use private final lock objects to synchronize classes that
  may interact with untrusted code </li>
</ul>ZBUG
á
squid:S3358˜
squidS3358&Ternary operators should not be nested"MAJOR*java:•<p>Just because you <em>can</em> do something, doesn't mean you should, and that's the case with nested ternary operations. Nesting ternary operators
results in the kind of code that may seem clear as day when you write it, but six months later will leave maintainers (or worse - future you)
scratching their heads and cursing.</p>
<p>Instead, err on the side of clarity, and use another line to express the nested operation as a separate statement.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public String getTitle(Person p) {

  return p.gender==Person.MALE?"Mr. ":p.isMarried()?"Mrs. ":"Miss " + p.getLastName();  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>

  String honorific = p.isMarried()?"Mrs. ":"Miss ";
  return p.gender==Person.MALE?"Mr. ": honorific + p.getLastName();
</pre>Z
CODE_SMELL
ˇ
squid:S2384Ô
squidS23849Mutable members should not be stored or returned directly"MINOR*java:á<p>Mutable objects are those whose state can be changed. For instance, an array is mutable, but a String is not. Mutable class members should never be
returned to a caller or accepted and stored directly. Doing so leaves you vulnerable to unexpected changes in your class state.</p>
<p>Instead use an unmodifiable <code>Collection</code> (via <code>Collections.unmodifiableCollection</code>,
<code>Collections.unmodifiableList</code>, ...) or make a copy of the mutable object, and store or return the copy instead.</p>
<p>This rule checks that arrays, collections and Dates are not stored or returned directly.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class A {
  private String [] strings;

  public A () {
    strings = new String[]{"first", "second"};
  }

  public String [] getStrings() {
    return strings; // Noncompliant
  }

  public void setStrings(String [] strings) {
    this.strings = strings;  // Noncompliant
  }
}

public class B {

  private A a = new A();  // At this point a.strings = {"first", "second"};

  public void wreakHavoc() {
    a.getStrings()[0] = "yellow";  // a.strings = {"yellow", "second"};
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class A {
  private String [] strings;

  public A () {
    strings = new String[]{"first", "second"};
  }

  public String [] getStrings() {
    return strings.clone();
  }

  public void setStrings(String [] strings) {
    this.strings = strings.clone();
  }
}

public class B {

  private A a = new A();  // At this point a.strings = {"first", "second"};

  public void wreakHavoc() {
    a.getStrings()[0] = "yellow";  // a.strings = {"first", "second"};
  }
}

</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/374">MITRE, CWE-374</a> - Passing Mutable Objects to an Untrusted Method </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/375">MITRE, CWE-375</a> - Returning a Mutable Object to an Untrusted Caller </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/zQCuAQ">CERT, OBJ05-J.</a> - Do not return references to private mutable class members
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/QIEVAQ">CERT, OBJ06-J.</a> - Defensively copy mutable inputs and mutable internal
  components </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/JQLEAw">CERT, OBJ13-J.</a> - Ensure that references to mutable objects are not exposed
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/kwCuAQ">CERT, OOP08-CPP.</a> - Do not return references to private data </li>
</ul>ZVULNERABILITY
´
squid:S2390õ
squidS2390VClasses should not access static members of their own subclasses during initialization"MAJOR*java:†<p>When a parent class references a static member of a subclass during its own initialization, the results will not be what you expect because the
child class won't exist yet. </p>
<p>In a best-case scenario, you'll see immediate failures in the code as a result. Worst-case, the damage will be more insidious and difficult to
track down.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class Parent {
  public static final int childVersion = Child.version;
}

class Child extends Parent {
  public static final int version = 6;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/display/java/DCL00-J.+Prevent+class+initialization+cycles">CERT, DCL00-J.</a> - Prevent
  class initialization cycles </li>
  <li> Java Language Specifications - <a href="http://docs.oracle.com/javase/specs/jls/se8/html/jls-12.html#jls-12.4">Section 12.4: Initialization of
  Classes and Interfaces</a> </li>
</ul>ZBUG
ò
squid:S1155à
squidS11559Collection.isEmpty() should be used to test for emptiness"MINOR*java:£<p>Using <code>Collection.size()</code> to test for emptiness works, but using <code>Collection.isEmpty()</code> makes the code more readable and can
be more performant. The time complexity of any <code>isEmpty()</code> method implementation should be <code>O(1)</code> whereas some implementations
of <code>size()</code> can be <code>O(n)</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (myCollection.size() == 0) {  // Noncompliant
  /* ... */
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if (myCollection.isEmpty()) {
  /* ... */
}
</pre>Z
CODE_SMELL
£
squid:S3346ì
squidS33463"assert" should only be used with boolean variables"MAJOR*java:ª<p>Since <code>assert</code> statements aren't executed by default (they must be enabled with JVM flags) developers should never rely on their
execution the evaluation of any logic required for correct program function.</p>
<h2>Noncompliant Code Example</h2>
<pre>
assert myList.remove(myList.get(0));  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
boolean removed = myList.remove(myList.get(0));
assert removed;
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/vwG7AQ">CERT, EXP06-J.</a> - Expressions used in assertions must not produce side
  effects </li>
</ul>
<h2>Deprecated</h2>
<p>This rule is deprecated, and will eventually be removed.</p>ZBUG
ò
squid:S1161à
squidS1161A"@Override" should be used on overriding and implementing methods"MAJOR*java:õ<p>Using the <code>@Override</code> annotation is useful for two reasons :</p>
<ul>
  <li> It elicits a warning from the compiler if the annotated method doesn't actually override anything, as in the case of a misspelling. </li>
  <li> It improves the readability of the source code by making it obvious that methods are overridden. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
class ParentClass {
  public boolean doSomething(){...}
}
class FirstChildClass extends ParentClass {
  public boolean doSomething(){...}  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class ParentClass {
  public boolean doSomething(){...}
}
class FirstChildClass extends ParentClass {
  @Override
  public boolean doSomething(){...}  // Compliant
}
</pre>
<h2>Exceptions</h2>
<p>This rule is relaxed when overriding a method from the <code>Object</code> class like <code>toString()</code>, <code>hashcode()</code>, ...</p>Z
CODE_SMELL
√
$squid:AssignmentInSubExpressionCheckö
squidAssignmentInSubExpressionCheck:Assignments should not be made from within sub-expressions"MAJOR*java2S1121:î<p>Assignments within sub-expressions are hard to spot and therefore make the code less readable. Ideally, sub-expressions should not have
side-effects.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if ((str = cont.substring(pos1, pos2)).isEmpty()) {  // Noncompliant
  //...
</pre>
<h2>Compliant Solution</h2>
<pre>
str = cont.substring(pos1, pos2);
if (str.isEmpty()) {
  //...
</pre>
<h2>Exceptions</h2>
<p>Assignments in <code>while</code> statement conditions, and assignments enclosed in relational expressions are allowed.</p>
<pre>
BufferedReader br = new BufferedReader(/* ... */);
String line;
while ((line = br.readLine()) != null) {...}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 13.1 - Assignment operators shall not be used in expressions that yield a Boolean value </li>
  <li> MISRA C++:2008, 6-2-1 - Assignment operators shall not be used in sub-expressions </li>
  <li> MISRA C:2012, 13.4 - The result of an assignment operator should not be used </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/481.html">MITRE, CWE-481</a> - Assigning instead of Comparing </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/nYFtAg">CERT, EXP45-C.</a> - Do not perform assignments in selection statements </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/1gCTAw">CERT, EXP51-J.</a> - Do not perform assignments in conditional expressions
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/KQvhAg">CERT, EXP19-CPP.</a> - Do not perform assignments in conditional expressions
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/KYIyAQ">CERT, MSC02-CPP.</a> - Avoid errors of omission </li>
</ul>Z
CODE_SMELL
Í
squid:S2629⁄
squidS2629C"Preconditions" and logging arguments should not require evaluation"MAJOR*java:Ú<p>Passing message arguments that require further evaluation into a Guava <code>com.google.common.base.Preconditions</code> check can result in a
performance penalty. That's because whether or not they're needed, each argument must be resolved before the method is actually called.</p>
<p>Similarly, passing concatenated strings into a logging method can also incur a needless performance hit because the concatenation will be performed
every time the method is called, whether or not the log level is low enough to show the message.</p>
<p>Instead, you should structure your code to pass static or pre-computed values into <code>Preconditions</code> conditions check and logging
calls.</p>
<p>Specifically, the built-in string formatting should be used instead of string concatenation, and if the message is the result of a method call,
then <code>Preconditions</code> should be skipped altoghether, and the relevant exception should be conditionally thrown instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
logger.log(Level.DEBUG, "Something went wrong: " + message);  // Noncompliant; string concatenation performed even when log level too high to show DEBUG messages

LOG.error("Unable to open file " + csvPath, e);  // Noncompliant

Preconditions.checkState(a &gt; 0, "Arg must be positive, but got " + a);  // Noncompliant. String concatenation performed even when a &gt; 0

Preconditions.checkState(condition, formatMessage());  // Noncompliant. formatMessage() invoked regardless of condition

Preconditions.checkState(condition, "message: %s", formatMessage());  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
logger.log(Level.SEVERE, "Something went wrong: %s ", message);  // String formatting only applied if needed

logger.log(Level.SEVERE, () -&gt; "Something went wrong: " + message); // since Java 8, we can use Supplier , which will be evaluated lazily

LOG.error("Unable to open file {}", csvPath, e);

if (LOG.isDebugEnabled() {
  LOG.debug("Unable to open file " + csvPath, e);  // this is compliant, because it will not evaluate if log level is above debug.
}

Preconditions.checkState(arg &gt; 0, "Arg must be positive, but got %d", a);  // String formatting only applied if needed

if (!condition) {
  throw new IllegalStateException(formatMessage());  // formatMessage() only invoked conditionally
}

if (!condition) {
  throw new IllegalStateException("message: " + formatMessage());
}
</pre>
<h2>Exceptions</h2>
<p><code>catch</code> blocks are ignored, because the performance penalty is unimportant on exceptional paths (catch block should not be a part of
standard program flow). Getters are ignored. This rule accounts for explicit test-level testing with SLF4J methods <code>isXXXEnabled</code> and
ignores the bodies of such <code>if</code> statements.</p>ZBUG
∏
squid:S1764®
squidS1764KIdentical expressions should not be used on both sides of a binary operator"MAJOR*java:∏<p>Using the same value on either side of a binary operator is almost always a mistake. In the case of logical operators, it is either a copy/paste
error and therefore a bug, or it is simply wasted code, and should be simplified. In the case of bitwise operators and most binary mathematical
operators, having the same value on both sides of an operator yields predictable results, and should be simplified.</p>
<p>This rule ignores <code>*</code>, <code>+</code>, and <code>=</code>. </p>
<h2>Noncompliant Code Example</h2>
<pre>
if ( a == a ) { // always true
  doZ();
}
if ( a != a ) { // always false
  doY();
}
if ( a == b &amp;&amp; a == b ) { // if the first one is true, the second one is too
  doX();
}
if ( a == b || a == b ) { // if the first one is true, the second one is too
  doW();
}

int j = 5 / 5; //always 1
int k = 5 - 5; //always 0
</pre>
<h2>Exceptions</h2>
<p>The specific case of testing a floating point value against itself is a valid test for <code>NaN</code> and is therefore ignored.</p>
<p>Similarly, left-shifting 1 onto 1 is common in the construction of bit masks, and is ignored.</p>
<pre>
float f;
if(f != f) { //test for NaN value
  System.out.println("f is NaN");
}

int i = 1 &lt;&lt; 1; // Compliant
int j = a &lt;&lt; a; // Noncompliant
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
  <li> <a href='/coding_rules#rule_key=squid%3AS1656'>S1656</a> - Implements a check on <code>=</code>. </li>
</ul>ZBUG
˘
squid:S2737È
squidS2737+"catch" clauses should do more than rethrow"MINOR*java:í<p>A <code>catch</code> clause that only rethrows the caught exception has the same effect as omitting the <code>catch</code> altogether and letting
it bubble up automatically, but with more code and the additional detrement of leaving maintainers scratching their heads. </p>
<p>Such clauses should either be eliminated or populated with the appropriate logic.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public String readFile(File f) {
  StringBuilder sb = new StringBuilder();
  try {
    FileReader fileReader = new FileReader(fileName);
    BufferedReader bufferedReader = new BufferedReader(fileReader);

    while((line = bufferedReader.readLine()) != null) {
      //...
  }
  catch (IOException e) {  // Noncompliant
    throw e;
  }
  return sb.toString();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public String readFile(File f) {
  StringBuilder sb = new StringBuilder();
  try {
    FileReader fileReader = new FileReader(fileName);
    BufferedReader bufferedReader = new BufferedReader(fileReader);

    while((line = bufferedReader.readLine()) != null) {
      //...
  }
  catch (IOException e) {
    logger.LogError(e);
    throw e;
  }
  return sb.toString();
}
</pre>
<p>or</p>
<pre>
public String readFile(File f) throws IOException {
  StringBuilder sb = new StringBuilder();
  FileReader fileReader = new FileReader(fileName);
  BufferedReader bufferedReader = new BufferedReader(fileReader);

  while((line = bufferedReader.readLine()) != null) {
    //...

  return sb.toString();
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>Z
CODE_SMELL
˝
squid:S3750Ì
squidS37504Spring "@Controller" classes should not use "@Scope""MAJOR*java:î<p>Spring <code>@Controller</code>s, <code>@Service</code>s, and <code>@Repository</code>s have <code>singleton</code> scope by default, meaning only
one instance of the class is ever instantiated in the application. Defining any other scope for one of these class types will result in needless churn
as new instances are created and destroyed. In a busy web application, this could cause a significant amount of needless additional load on the
server.</p>
<p>This rule raises an issue when the <code>@Scope</code> annotation is applied to a <code>@Controller</code>, <code>@Service</code>, or
<code>@Repository</code> with any value but "singleton". <code>@Scope("singleton")</code> is redundant, but ignored.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@Scope("prototype")  // Noncompliant
@Controller
public class HelloWorld {
</pre>
<h2>Compliant Solution</h2>
<pre>
@Controller
public class HelloWorld {
</pre>ZBUG
Ê
squid:S1450÷
squidS1450TPrivate fields only used as local variables in methods should become local variables"MINOR*java:÷<p>When the value of a private field is always assigned to in a class' methods before being read, then it is not being used to store class
information. Therefore, it should become a local variable in the relevant methods to prevent any misunderstanding.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo {
  private int singularField;

  public void doSomething(int y) {
    singularField = y + 5;
    ...
    if(singularField == 0 {...}
    ...
  }

  public void doSomethingElse(int y) {
    singularField = y + 3;
    ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo {

  public void doSomething(int y) {
    int singularField = y + 5;
    ...
  }

  public void doSomethingElse(int y) {
    int singularField = y + 3;
    ...
  }
}
</pre>
<h2>Exceptions</h2>
<p>This rule doesn't raise any issue on annotated field.</p>Z
CODE_SMELL
ï
squid:S1215Ö
squidS1215FExecution of the Garbage Collector should be triggered only by the JVM"MINOR*java:ö<p>Calling <code>System.gc()</code> or <code>Runtime.getRuntime().gc()</code> is a bad idea for a simple reason:</p>
<p>there is no way to know exactly what will be done under the hood by the JVM because the behavior will depend on its vendor, version and
options:</p>
<ul>
  <li> Will the whole application be frozen during the call? </li>
  <li> Is the -XX:DisableExplicitGC option activated? </li>
  <li> Will the JVM simply ignore the call? </li>
  <li> ... </li>
</ul>
<p>An application relying on those unpredictable methods is also unpredictable and therefore broken.</p>
<p>The task of running the garbage collector should be left exclusively to the JVM.</p>ZBUG
Õ
squid:MaximumInheritanceDepth´
squidMaximumInheritanceDepth2Inheritance tree of classes should not be too deep"MAJOR*java2S110:µ<p>Inheritance is certainly one of the most valuable concepts in object-oriented programming. It's a way to compartmentalize and reuse code by
creating collections of attributes and behaviors called classes which can be based on previously created classes. But abusing this concept by creating
a deep inheritance tree can lead to very complex and unmaintainable source code. Most of the time a too deep inheritance tree is due to bad object
oriented design which has led to systematically use 'inheritance' when for instance 'composition' would suit better.</p>
<p>This rule raises an issue when the inheritance tree, starting from <code>Object</code> has a greater depth than is allowed. </p>Z
CODE_SMELL
°	
squid:IndentationCheckÜ	
squidIndentationCheck+Source code should be indented consistently"MINOR*java2S1120:ù<p>Proper indentation is a simple and effective way to improve the code's readability. Consistent indentation among the developers within a team also
reduces the differences that are committed to source control systems, making code reviews easier. </p>
<p>By default this rule checks that each block of code is indented, although it does not check the size of the indent. Parameter "indentSize" allows
the expected indent size to be defined. Only the first line of a badly indented section is reported.</p>
<h2>Noncompliant Code Example</h2>
<p>With an indent size of 2:</p>
<pre>
class Foo {
  public int a;
   public int b;   // Noncompliant, expected to start at column 4

...

  public void doSomething() {
    if(something) {
          doSomethingElse();  // Noncompliant, expected to start at column 6
  }   // Noncompliant, expected to start at column 4
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class Foo {
  public int a;
  public int b;

...

  public void doSomething() {
    if(something) {
        doSomethingElse();
    }
  }
}
</pre>Z
CODE_SMELL
µ

squid:S3749•

squidS37493Members of Spring components should be "@Autowired""CRITICAL*java:¿	<p>Spring <code>@Controller</code>s, <code>@Service</code>s, and <code>@Repository</code>s are singletons by default, meaning only one instance of the
class is ever instantiated in the application. Typically such a class might have a few <code>static</code> members, such as a logger, but all
non-<code>static</code> members should be managed by Spring. That is, they should have the <code>@Autowired</code> annotation. </p>
<p>Having non-<code>@Autowired</code> members in one of these classes could indicate an attempt to manage state. Because they are singletons, such an
attempt is almost guaranteed to eventually expose data from User1's session to User2. </p>
<p>This rule raises an issue when a singleton <code>@Controller</code>, <code>@Service</code>, or <code>@Repository</code> has
non-<code>static</code>, non-<code>@Autowired</code> members.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@Controller
public class HelloWorld {

  private String name = null;

  @RequestMapping("/greet", method = GET)
  public String greet(String greetee) {

    if (greetee != null) {
      this.name = greetee;
    }

    return "Hello " + this.name;  // if greetee is null, you see the previous user's data
  }
}
</pre>ZVULNERABILITY
˚
"squid:SwitchLastCaseIsDefaultCheck‘
squidSwitchLastCaseIsDefaultCheck5"switch" statements should end with "default" clauses"CRITICAL*java2S131:”<p>The requirement for a final <code>default</code> clause is defensive programming. The clause should either take appropriate action, or contain a
suitable comment as to why no action is taken. When the <code>switch</code> covers all current values of an <code>enum</code> - and especially when it
doesn't - a <code>default</code> case should still be used because there is no guarantee that the <code>enum</code> won't be extended.</p>
<h2>Noncompliant Code Example</h2>
<pre>
switch (param) {  //missing default clause
  case 0:
    doSomething();
    break;
  case 1:
    doSomethingElse();
    break;
}

switch (param) {
  default: // default clause should be the last one
    error();
    break;
  case 0:
    doSomething();
    break;
  case 1:
    doSomethingElse();
    break;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
switch (param) {
  case 0:
    doSomething();
    break;
  case 1:
    doSomethingElse();
    break;
  default:
    error();
    break;
}
</pre>
<h2>Exceptions</h2>
<p>If the <code>switch</code> parameter is an <code>Enum</code> and if all the constants of this enum are used in the <code>case</code> statements,
then no <code>default</code> clause is expected.</p>
<p>Example:</p>
<pre>
public enum Day {
    SUNDAY, MONDAY
}
...
switch(day) {
  case SUNDAY:
    doSomething();
    break;
  case MONDAY:
    doSomethingElse();
    break;
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 15.0 - The MISRA C <em>switch</em> syntax shall be used. </li>
  <li> MISRA C:2004, 15.3 - The final clause of a switch statement shall be the default clause </li>
  <li> MISRA C++:2008, 6-4-3 - A switch statement shall be a well-formed switch statement. </li>
  <li> MISRA C++:2008, 6-4-6 - The final clause of a switch statement shall be the default-clause </li>
  <li> MISRA C:2012, 16.1 - All switch statements shall be well-formed </li>
  <li> MISRA C:2012, 16.4 - Every <em>switch</em> statement shall have a <em>default</em> label </li>
  <li> MISRA C:2012, 16.5 - A <em>default</em> label shall appear as either the first or the last <em>switch label</em> of a <em>switch</em> statement
  </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/478.html">MITRE, CWE-478</a> - Missing Default Case in Switch Statement </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/YgE">CERT, MSC01-C.</a> - Strive for logical completeness </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/JoIyAQ">CERT, MSC01-CPP.</a> - Strive for logical completeness </li>
</ul>Z
CODE_SMELL
›
squid:S1854Õ
squidS1854Dead stores should be removed"MAJOR*java:ã<p>A dead store happens when a local variable is assigned a value, including <code>null</code>, that is not read by any subsequent instruction.
Calculating or retrieving a value only to then overwrite it or throw it away, could indicate a serious error in the code. Even if it's not an error,
it is at best a waste of resources. </p>
<p>Even assigning <code>null</code> to a variable is a dead store if the variable is not subsequently used. Assigning null as a hint to the garbage
collector used to be common practice, but is no longer needed and such code should be eliminated.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void pow(int a, int b) {
  if(b == 0) {
    return 0;
  }
  int x = a;
  for(int i= 1, i &lt; b, i++) {
    x = x * a;  //Dead store because the last return statement should return x instead of returning a
  }
  return a;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void pow(int a, int b) {
  if(b == 0) {
    return 0;
  }
  int x = a;
  for(int i= 1, i &lt; b, i++) {
    x = x * a;
  }
  return x;
}
</pre>
<h2>Exceptions</h2>
<p>This rule ignores initializations to -1, 0, 1, <code>null</code>, empty string (<code>""</code>), <code>true</code>, and <code>false</code>.</p>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/563.html">MITRE, CWE-563</a> - Assignment to Variable without Use ('Unused Variable') </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/QYA5">CERT, MSC13-C.</a> - Detect and remove unused values </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/S4IyAQ">CERT, MSC13-CPP.</a> - Detect and remove unused values </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/uQCSBg">CERT, MSC56-J.</a> - Detect and remove superfluous code and values </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>ZBUG
Ñ
squid:S1612Ù
squidS16121Lambdas should be replaced with method references"MINOR*java:ó<p>Method/constructor references are more compact and readable than using lambdas, and are therefore preferred. Similarly, <code>null</code> checks
can be replaced with references to the <code>Objects::isNull</code> and <code>Objects::nonNull</code> methods.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class A {
  void process(List&lt;A&gt; list) {
    list.stream()
      .map(a -&gt; a.&lt;String&gt;getObject())
      .forEach(a -&gt; { System.out.println(a); });
  }

  &lt;T&gt; T getObject() {
    return null;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class A {
  void process(List&lt;A&gt; list) {
    list.stream()
      .map(A::&lt;String&gt;getObject)
      .forEach(System.out::println);
  }

  &lt;T&gt; T getObject() {
    return null;
  }
}
</pre>Z
CODE_SMELL
‰	
squid:S1609‘	
squidS1609X@FunctionalInterface annotation should be used to flag Single Abstract Method interfaces"CRITICAL*java:Õ<p>A Single Abstract Method (SAM) interface is a Java interface containing only one method. The Java API is full of SAM interfaces, such as
<code>java.lang.Runnable</code>, <code>java.awt.event.ActionListener</code>, <code>java.util.Comparator</code> and
<code>java.util.concurrent.Callable</code>. SAM interfaces have a special place in Java 8 because they can be implemented using Lambda expressions or
Method references. </p>
<p>Using <code>@FunctionalInterface</code> forces a compile break when an additional, non-overriding abstract method is added to a SAM, which would
break the use of Lambda implementations.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public interface Changeable&lt;T&gt; {
  public void change(T o);
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@FunctionalInterface
public interface Changeable&lt;T&gt; {
  public void change(T o);
}
</pre>
<h2>Deprecated</h2>
<p>This rule is deprecated, and will eventually be removed.</p>Z
CODE_SMELL
ã
squid:S2189˚
squidS2189Loops should not be infinite"BLOCKER*java:∏<p>An infinite loop is one that will never end while the program is running, i.e., you have to kill the program to get out of the loop. Whether it is
by meeting the loop's end condition or via a <code>break</code>, every loop should have an end condition.</p>
<h2>Noncompliant Code Example</h2>
<pre>
for (;;) {  // Noncompliant; end condition omitted
  // ...
}

int j;
while (true) { // Noncompliant; end condition omitted
  j++;
}

int k;
boolean b = true;
while (b) { // Noncompliant; b never written to in loop
  k++;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
int j;
while (true) { // reachable end condition added
  j++;
  if (j  == Integer.MIN_VALUE) {  // true at Integer.MAX_VALUE +1
    break;
  }
}

int k;
boolean b = true;
while (b) {
  k++;
  b = k &lt; Integer.MAX_VALUE;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/PYHfAw">CERT, MSC01-J.</a> - Do not use an empty infinite loop </li>
</ul>ZBUG
≥
squid:S3046£
squidS30468"wait" should not be called when multiple locks are held"BLOCKER*java:ƒ<p>When two locks are held simultaneously, a <code>wait</code> call only releases one of them. The other will be held until some other thread requests
a lock on the awaited object. If no unrelated code tries to lock on that object, then all other threads will be locked out, resulting in a
deadlock.</p>
<h2>Noncompliant Code Example</h2>
<pre>
synchronized (this.mon1) {  // threadB can't enter this block to request this.mon2 lock &amp; release threadA
	synchronized (this.mon2) {
		this.mon2.wait();  // Noncompliant; threadA is stuck here holding lock on this.mon1
	}
}
</pre>ZBUG
¿
squid:S2047∞
squidS2047OThe names of methods with boolean return values should start with "is" or "has""MAJOR*java:µ<p>Well-named functions can allow the users of your code to understand at a glance what to expect from the function - even before reading the
documentation. Toward that end, methods returning a boolean should have names that start with "is" or "has" rather than with "get".</p>
<h2>Noncompliant Code Example</h2>
<pre>
public boolean getFoo() { // Noncompliant
  // ...
}

public boolean getBar(Bar c) { // Noncompliant
  // ...
}

public boolean testForBar(Bar c) { // Compliant - The method does not start by 'get'.
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public boolean isFoo() {
  // ...
}

public boolean hasBar(Bar c) {
  // ...
}

public boolean testForBar(Bar c) {
  // ...
}
</pre>
<h2>Exceptions</h2>
<p>Overriding methods are excluded.</p>
<pre>
@Override
public boolean getFoo(){
  // ...
}
</pre>Z
CODE_SMELL
˚
squid:S1075Î
squidS1075URIs should not be hardcoded"MINOR*java:£<p>Hard coding a URI makes it difficult to test a program: path literals are not always portable across operating systems, a given absolute path may
not exist on a specific test environment, a specified Internet URL may not be available when executing the tests, production environment filesystems
usually differ from the development environment, ...etc. For all those reasons, a URI should never be hard coded. Instead, it should be replaced by
customizable parameter.</p>
<p>Further even if the elements of a URI are obtained dynamically, portability can still be limited if the path-delimiters are hard-coded.</p>
<p>This rule raises an issue when URI's or path delimiters are hard coded.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo {
  public Collection&lt;User&gt; listUsers() {
    File userList = new File("/home/mylogin/Dev/users.txt"); // Non-Compliant
    Collection&lt;User&gt; users = parse(userList);
    return users;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo {
  // Configuration is a class that returns customizable properties: it can be mocked to be injected during tests.
  private Configuration config;
  public Foo(Configuration myConfig) {
    this.config = myConfig;
  }
  public Collection&lt;User&gt; listUsers() {
    // Find here the way to get the correct folder, in this case using the Configuration object
    String listingFolder = config.getProperty("myApplication.listingFolder");
    // and use this parameter instead of the hard coded path
    File userList = new File(listingFolder, "users.txt"); // Compliant
    Collection&lt;User&gt; users = parse(userList);
    return users;
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/qQCHAQ">CERT, MSC03-J.</a> - Never hard code sensitive information </li>
</ul>Z
CODE_SMELL
–
squid:S3010¿
squidS30103Static fields should not be updated in constructors"MAJOR*java:Ë<p>Assigning a value to a <code>static</code> field in a constructor could cause unreliable behavior at runtime since it will change the value for all
instances of the class.</p>
<p>Instead remove the field's <code>static</code> modifier, or initialize it statically.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Person {
  static Date dateOfBirth;
  static int expectedFingers;

  public Person(date birthday) {
    dateOfBirth = birthday;  // Noncompliant; now everyone has this birthday
    expectedFingers = 10;  // Noncompliant
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Person {
  Date dateOfBirth;
  static int expectedFingers = 10;

  public Person(date birthday) {
    dateOfBirth = birthday;
  }
}
</pre>ZBUG
√
squid:S1191≥
squidS11910Classes from "sun.*" packages should not be used"MAJOR*java:◊<p>Classes in the <code>sun.*</code> or <code>com.sun.*</code> packages are considered implementation details, and are not part of the Java API.</p>
<p>They can cause problems when moving to new versions of Java because there is no backwards compatibility guarantee. Similarly, they can cause
problems when moving to a different Java vendor, such as OpenJDK.</p>
<p>Such classes are almost always wrapped by Java API classes that should be used instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
import com.sun.jna.Native;     // Noncompliant
import sun.misc.BASE64Encoder; // Noncompliant
</pre>Z
CODE_SMELL
¯
squid:S1190Ë
squidS1190+Future keywords should not be used as names"BLOCKER*java:è<p>Through Java's evolution keywords have been added. While code that uses those words as identifiers may be compilable under older versions of Java,
it will not be under modern versions. </p>
<p>Following keywords are marked as invalid identifiers </p>
<table>
  <tbody>
    <tr>
      <th>Keyword</th>
      <th>Added</th>
    </tr>
    <tr>
      <td><code>_</code></td>
      <td>9</td>
    </tr>
    <tr>
      <td><code>enum</code></td>
      <td>5.0</td>
    </tr>
  </tbody>
</table>
<p><code>assert</code> and <code>strictfp</code> are another example of valid identifiers which became keywords in later versions, however as
documented in SONARJAVA-285, it is not easily possible to support parsing of the code for such old versions, therefore they are not supported by this
rule.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething() {
  int enum = 42;            // Noncompliant
  String _ = "";   // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething() {
  int magic = 42;
}
</pre>Z
CODE_SMELL
»
squid:S2093∏
squidS2093!Try-with-resources should be used"CRITICAL*java:Ë<p>Java 7 introduced the try-with-resources statement, which guarantees that the resource in question will be closed. Since the new syntax is closer
to bullet-proof, it should be preferred over the older <code>try</code>/<code>catch</code>/<code>finally</code> version.</p>
<p>This rule checks that <code>close</code>-able resources are opened in a try-with-resources statement.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>7</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
FileReader fr = null;
BufferedReader br = null;
try {
  fr = new FileReader(fileName);
  br = new BufferedReader(fr);
  return br.readLine();
} catch (...) {
} finally {
  if (br != null) {
    try {
      br.close();
    } catch(IOException e){...}
  }
  if (fr != null ) {
    try {
      br.close();
    } catch(IOException e){...}
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
try (
    FileReader fr = new FileReader(fileName);
    BufferedReader br = new BufferedReader(fr)
  ) {
  return br.readLine();
}
catch (...) {}
</pre>
<p>or</p>
<pre>
try (BufferedReader br =
        new BufferedReader(new FileReader(fileName))) { // no need to name intermediate resources if you don't want to
  return br.readLine();
}
catch (...) {}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/MACfBg">CERT, ERR54-J.</a> - Use a try-with-resources statement to safely handle
  closeable resources </li>
</ul>Z
CODE_SMELL
ª
common-neutral:FailedUnitTestsò
common-neutralFailedUnitTests!Failed unit tests should be fixed"MAJOR*neutral:ºTest failures or errors generally indicate that regressions have been introduced. Those tests should be handled as soon as possible to reduce the cost to fix the corresponding regressions.ZBUG
ò
common-neutral:SkippedUnitTestsÙ
common-neutralSkippedUnitTests4Skipped unit tests should be either removed or fixed"MAJOR*neutral:~Skipped unit tests are considered as dead code. Either they should be activated again (and updated) or they should be removed.Z
CODE_SMELL
¸
common-neutral:DuplicatedBlocksÿ
common-neutralDuplicatedBlocks2Source files should not have any duplicated blocks"MAJOR*neutral:dAn issue is created on a file as soon as there is at least one block of duplicated code on this fileZ
CODE_SMELL
¶
)common-neutral:InsufficientCommentDensity¯
common-neutralInsufficientCommentDensity>Source files should have a sufficient density of comment lines"MAJOR*neutral:ÌAn issue is created on a file as soon as the density of comment lines on this file is less than the required threshold. The number of comment lines to be written in order to reach the required threshold is provided by each issue message.Z
CODE_SMELL
Î
'common-neutral:InsufficientLineCoverageø
common-neutralInsufficientLineCoverage3Lines should have sufficient coverage by unit tests"MAJOR*neutral:¡An issue is created on a file as soon as the line coverage on this file is less than the required threshold. It gives the number of lines to be covered in order to reach the required threshold.Z
CODE_SMELL
ˆ
)common-neutral:InsufficientBranchCoverage»
common-neutralInsufficientBranchCoverage6Branches should have sufficient coverage by unit tests"MAJOR*neutral:≈An issue is created on a file as soon as the branch coverage on this file is less than the required threshold.It gives the number of branches to be covered in order to reach the required threshold.Z
CODE_SMELL
Å
Ucheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.ModifiedControlVariableCheckß

checkstyleJcom.puppycrawl.tools.checkstyle.checks.coding.ModifiedControlVariableCheckModified Control Variable"MAJOR*java2*Checker/TreeWalker/ModifiedControlVariable:ÏCheck for ensuring that for loop control variables are not modified inside the for block.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AForLoopCounterChangedCheck'>ForLoopCounterChangedCheck</a> instead.
</p>Z
CODE_SMELL
Ê
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.MethodLengthCheckò

checkstyle>com.puppycrawl.tools.checkstyle.checks.sizes.MethodLengthCheckMethod Length"MAJOR*java2Checker/TreeWalker/MethodLength:Checks for long methods.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS138'>S138</a> instead.
</p>@Z
CODE_SMELL
Ü
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.IllegalInstantiationCheckØ

checkstyleGcom.puppycrawl.tools.checkstyle.checks.coding.IllegalInstantiationCheckIllegal Instantiation"MAJOR*java2'Checker/TreeWalker/IllegalInstantiation:˛Checks for illegal instantiations where a factory method is preferred. Depending on the project, for some classes it might be preferable to create instances through factory methods rather than calling the constructor. A simple example is the <code>java.lang.Boolean</code> class. In order to save memory and CPU cycles, it is preferable to use the predefined constants TRUE and FALSE. Constructor invocations should be replaced by calls to <code>Boolean.valueOf()</code>. Some extremely performance sensitive projects may require the use of factory methods for other classes as well, to enforce the usage of number caches or object pools.Z
CODE_SMELL
‡
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.LocalFinalVariableNameChecká

checkstyleIcom.puppycrawl.tools.checkstyle.checks.naming.LocalFinalVariableNameCheckLocal Final Variable Name"MAJOR*java2)Checker/TreeWalker/LocalFinalVariableName:ŒChecks that local final variable names, including catch parameters, conform to the specified format

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00117'>S00117</a> instead.
</p>Z
CODE_SMELL
è
=checkstyle:com.puppycrawl.tools.checkstyle.checks.RegexpCheckÕ

checkstyle2com.puppycrawl.tools.checkstyle.checks.RegexpCheckRegexp"MAJOR*java2Checker/TreeWalker/Regexp:MA check that makes sure that a specified pattern exists (or not) in the file.@Z
CODE_SMELL
É
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.MethodNameCheck∂

checkstyle=com.puppycrawl.tools.checkstyle.checks.naming.MethodNameCheckMethod Name"MAJOR*java2Checker/TreeWalker/MethodName:£Checks that method names conform to the specified format

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00100'>S00100</a> instead.
</p>Z
CODE_SMELL
˚
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.blocks.NeedBracesCheckÆ

checkstyle=com.puppycrawl.tools.checkstyle.checks.blocks.NeedBracesCheckNeed Braces"MINOR*java2Checker/TreeWalker/NeedBraces:ô<p>
Checks for braces around code blocks.
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00121'>S00121</a> instead.
</p>@Z
CODE_SMELL
°
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.AvoidStaticImportCheckÃ

checkstyleEcom.puppycrawl.tools.checkstyle.checks.imports.AvoidStaticImportCheckAvoid Static Import"MINOR*java2$Checker/TreeWalker/AvoidStaticImport:¢<p> Checks that there are no static import statements. Rationale: Importing static members can lead to naming conflicts between class' members. It may lead to poor code readability since it may no longer be clear what class a member resides in (without looking at the import statement).</p>Z
CODE_SMELL
—
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.annotation.AnnotationLocationCheck¯

checkstyleIcom.puppycrawl.tools.checkstyle.checks.annotation.AnnotationLocationCheckAnnotation Location"MAJOR*java2%Checker/TreeWalker/AnnotationLocation:…<p>Check location of annotation on language elements. By default, Check enforce to locate annotations immetiately after documentation block and before target element, annotation should be located on separate line from target element.</p>

<p>Example:</p>

<pre>
@Override
@Nullable
public String getNameIfPresent() { ... }
</pre>Z
CODE_SMELL
‘
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.SummaryJavadocCheckÇ

checkstyleBcom.puppycrawl.tools.checkstyle.checks.javadoc.SummaryJavadocCheckJavadoc summary"MAJOR*java2&Checker/TreeWalker/SummaryJavadocCheck:^Checks that Javadoc summary sentence does not contain phrases that are not recommended to use.Z
CODE_SMELL
Ü
Ocheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocParagraphCheck≤

checkstyleDcom.puppycrawl.tools.checkstyle.checks.javadoc.JavadocParagraphCheckJavadoc Paragraph"MAJOR*java2#Checker/TreeWalker/JavadocParagraph:åChecks that:
<ul>
    <li>There is one blank line between each of two paragraphs and one blank line before the at-clauses block if it is present.</li>
    <li>Each paragraph but the first has &lt;p&gt; immediately before the first word, with no space after.</li>
</ul>Z
CODE_SMELL
Œ
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.PackageNameCheckÄ

checkstyle>com.puppycrawl.tools.checkstyle.checks.naming.PackageNameCheckPackage name"MAJOR*java2Checker/TreeWalker/PackageName:Í<p>
Checks that package names conform to the specified format. The default value of format
       has been chosen to match the requirements in the Java Language specification and the Sun coding conventions.
       However both underscores and uppercase letters are rather uncommon, so most configurations should probably
       assign value ^[a-z]+(\.[a-z][a-z0-9]*)*$ to format
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00120'>S00120</a> instead.
</p>Z
CODE_SMELL
ß
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.ExplicitInitializationCheckŒ

checkstyleIcom.puppycrawl.tools.checkstyle.checks.coding.ExplicitInitializationCheckExplicit Initialization"MAJOR*java2)Checker/TreeWalker/ExplicitInitialization:óChecks if any class or object member explicitly initialized to default for its type value (null for object references, zero for numeric types and char and false for boolean).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS3052'>S3052</a> instead.
</p>Z
CODE_SMELL
Ê
Echeckstyle:com.puppycrawl.tools.checkstyle.checks.coding.NoCloneCheckú

checkstyle:com.puppycrawl.tools.checkstyle.checks.coding.NoCloneCheckNo Clone"MAJOR*java2Checker/TreeWalker/NoClone:í<p> Checks that the clone method is not overridden from the Object class.</p>

<p>Rationale: The clone method relies on strange/hard to follow rules that do not work it all situations. Consequently, it is difficult to override correctly. Below are some of the rules/reasons why the clone method should be avoided.
<ul>
    <li>Classes supporting the clone method should implement the Cloneable interface but the Cloneable interface does not include the clone method. As a result, it doesn't enforce the method override.</li>
    <li>The Cloneable interface forces the Object's clone method to work correctly. Without implementing it, the Object's clone method will throw a CloneNotSupportedException.</li>
    <li>Non-final classes must return the object returned from a call to super.clone().</li>
    <li>Final classes can use a constructor to create a clone which is different from non-final classes.</li>
    <li>If a super class implements the clone method incorrectly all subclasses calling super.clone() are doomed to failure.</li>
    <li>If a class has references to mutable objects then those object references must be replaced with copies in the clone method after calling super.clone().</li>
    <li>The clone method does not work correctly with final mutable object references because final references cannot be reassigned.</li>
    <li>If a super class overrides the clone method then all subclasses must provide a correct clone implementation.</li>
</ul></p>
<p>Two alternatives to the clone method, in some cases, is a copy constructor or a static factory method to return copies of an object. Both of these approaches are simpler and do not conflict with final fields. The do not force the calling client to handle a CloneNotSuportException. They also are typed therefore no casting is necessary. Finally, they are more flexible since they can take interface types rather than concrete classes.</p>

<p>Sometimes a copy constructor or static factory is not an acceptable alternative to the clone method. The example below highlights the limitation of a copy constructor (or static factory). Assume Square is a subclass for Shape.</p>
<p>
<pre>
  Shape s1 = new Square();
  System.out.println(s1 instanceof Square); //true
</pre></p>
<p>...assume at this point the code knows nothing of s1 being a Square that's the beauty of polymorphism but the code wants to copy the Square which is declared as a Shape, its super type...</p>
<p>
<pre>
  Shape s2 = new Shape(s1); //using the copy constructor
  System.out.println(s2 instanceof Square); //false
</pre></p>

<p>The working solution (without knowing about all subclasses and doing many casts) is to do the following (assuming correct clone implementation).<br/>
<pre>
  Shape s2 = s1.clone();
  System.out.println(s2 instanceof Square); //true
</pre></p>

<p>Just keep in mind if this type of polymorphic cloning is required then a properly implemented clone method may be the best choice.</p>

<p>Much of this information was taken from Effective Java: Programming Language Guide First Edition by Joshua Bloch pages 45-52. Give Bloch credit for writing an excellent book.</p>

<p>This check is almost exactly the same as the "No Finalizer Check".</p>Z
CODE_SMELL
»
Qcheckstyle:com.puppycrawl.tools.checkstyle.checks.modifier.RedundantModifierCheckÚ

checkstyleFcom.puppycrawl.tools.checkstyle.checks.modifier.RedundantModifierCheckRedundant Modifier"MINOR*java2$Checker/TreeWalker/RedundantModifier:GChecks for redundant modifiers in interface and annotation definitions.@Z
CODE_SMELL
º
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.NoWhitespaceBeforeCheck„

checkstyleIcom.puppycrawl.tools.checkstyle.checks.whitespace.NoWhitespaceBeforeCheckNo Whitespace Before"MINOR*java2%Checker/TreeWalker/NoWhitespaceBefore:2Checks that there is no whitespace before a token.@Z
CODE_SMELL
ı
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocPackageCheck£

checkstyleBcom.puppycrawl.tools.checkstyle.checks.javadoc.JavadocPackageCheckJavadoc Package"MINOR*java2Checker/JavadocPackage:é<p>Checks that each Java package has a Javadoc file used for commenting. By default it only allows a package-info.java file, but can be configured to allow a package.html file. An error will be reported if both files exist as this is not allowed by the Javadoc tool.</p>Z
CODE_SMELL
Ó
Kcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocStyleCheckû

checkstyle@com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocStyleCheckJavadoc Style"MAJOR*java2Checker/TreeWalker/JavadocStyle:ÇValidates Javadoc comments to help ensure they are well formed. The following checks are performed:
    <ul>
      <li>Ensures the first sentence ends with proper punctuation (That is a period, question mark, or exclamation mark, by default). 
      Javadoc automatically places the first sentence in the method summary table and index. With out proper punctuation the Javadoc may be malformed. 
      All items eligible for the {@inheritDoc} tag are exempt from this requirement.</li>
      <li>Check text for Javadoc statements that do not have any description. 
      This includes both completely empty Javadoc, and Javadoc with only tags such as @param and @return.</li>
      <li>Check text for incomplete HTML tags. Verifies that HTML tags have corresponding end tags and issues an "Unclosed HTML tag found:" error if not. 
      An "Extra HTML tag found:" error is issued if an end tag is found without a previous open tag.</li>
      <li>Check that a package Javadoc comment is well-formed (as described above) and NOT missing from any package-info.java files.</li>
      <li>Check for allowed HTML tags. The list of allowed HTML tags is "a", "abbr", "acronym", "address", "area", "b", 
      "bdo", "big", "blockquote", "br", "caption", "cite", "code", "colgroup", "del", "div", "dfn", "dl", "em", "fieldset", 
      "h1" to "h6", "hr", "i", "img", "ins", "kbd", "li", "ol", "p", "pre", "q", "samp", "small", "span", "strong", 
      "sub", "sup", "table", "tbody", "td", "tfoot", "th", "thread", "tr", "tt", "ul"</li>
    </ul>@Z
CODE_SMELL
Á
Zcheckstyle:com.puppycrawl.tools.checkstyle.checks.metrics.BooleanExpressionComplexityCheckà

checkstyleOcom.puppycrawl.tools.checkstyle.checks.metrics.BooleanExpressionComplexityCheckBoolean Expression Complexity"MAJOR*java2.Checker/TreeWalker/BooleanExpressionComplexity:æRestricts nested boolean operators (&&, || and ^) to a specified depth (default = 3).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1067'>S1067</a> instead.
</p>@Z
CODE_SMELL
Å
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.ClassTypeParameterNameCheck®

checkstyleIcom.puppycrawl.tools.checkstyle.checks.naming.ClassTypeParameterNameCheck"Class Type(Generic) Parameter Name"MAJOR*java2)Checker/TreeWalker/ClassTypeParameterName:ÊChecks that class parameter names conform to the specified format

<p>
The following code snippet illustrates this rule for format "^[A-Z]$":
</p>
<pre>
class Something&lt;type&gt; { // Non-compliant
}

class Something&lt;T&gt; { // Compliant
}
</pre>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00119'>S00119</a> instead.
</p>Z
CODE_SMELL
î
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.UnusedImportsCheck√

checkstyleAcom.puppycrawl.tools.checkstyle.checks.imports.UnusedImportsCheckUnused Imports"INFO*java2 Checker/TreeWalker/UnusedImports:ßChecks for unused import statements.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AUselessImportCheck'>UselessImportCheck</a> instead.
</p>Z
CODE_SMELL
ß
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.NestedTryDepthCheck÷

checkstyleAcom.puppycrawl.tools.checkstyle.checks.coding.NestedTryDepthCheckNested Try Depth"MAJOR*java2!Checker/TreeWalker/NestedTryDepth:∂Restricts nested try-catch-finally blocks to a specified depth (default = 1).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1141'>S1141</a> instead.
</p>Z
CODE_SMELL
˙
Ycheckstyle:com.puppycrawl.tools.checkstyle.checks.design.HideUtilityClassConstructorCheckú

checkstyleNcom.puppycrawl.tools.checkstyle.checks.design.HideUtilityClassConstructorCheckHide Utility Class Constructor"MAJOR*java2.Checker/TreeWalker/HideUtilityClassConstructor:‘Make sure that utility classes (classes that contain only static methods) do not have a public constructor.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1118'>S1118</a> instead.
</p>Z
CODE_SMELL
Ë
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.GenericWhitespaceCheckê

checkstyleHcom.puppycrawl.tools.checkstyle.checks.whitespace.GenericWhitespaceCheckGeneric Whitespace"MINOR*java2$Checker/TreeWalker/GenericWhitespace:‰<p>Checks that the whitespace around the Generic tokens < and >  is correct to the typical convention. The convention is not configurable.</p>
<p>
For example the following is legal:
</p>
<pre>
  List<Integer> x = new ArrayList<Integer>();
  List<List<Integer>> y = new ArrayList<List<Integer>>();
</pre>
<p>
But the following example is not:
</p>
<pre>
  List < Integer > x = new ArrayList < Integer > ();
  List < List < Integer > > y = new ArrayList < List < Integer > > ();
</pre>Z
CODE_SMELL
–
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.IllegalTypeCheckÇ

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.IllegalTypeCheckIllegal Type"MAJOR*java2Checker/TreeWalker/IllegalType:kChecks that particular class are never used as types in variable declarations, return values or parameters.@Z
CODE_SMELL
ê
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.NoLineWrapCheckø

checkstyleAcom.puppycrawl.tools.checkstyle.checks.whitespace.NoLineWrapCheckNo Line Wrap"MAJOR*java2Checker/TreeWalker/NoLineWrap:•Checks that chosen statements are not line-wrapped. By default this Check restricts wrapping import and package statements, but it's possible to check any statement.@Z
CODE_SMELL
±
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.WhitespaceAroundCheck⁄

checkstyleGcom.puppycrawl.tools.checkstyle.checks.whitespace.WhitespaceAroundCheckWhitespace Around"MINOR*java2#Checker/TreeWalker/WhitespaceAround:0Checks that a token is surrounded by whitespace.@Z
CODE_SMELL
â
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.NestedForDepthCheck∏

checkstyleAcom.puppycrawl.tools.checkstyle.checks.coding.NestedForDepthCheckNested For Depth"MAJOR*java2!Checker/TreeWalker/NestedForDepth:òRestricts nested for blocks to a specified depth.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS134'>S134</a> instead.
</p>Z
CODE_SMELL
œ
?checkstyle:com.puppycrawl.tools.checkstyle.checks.UpperEllCheckã

checkstyle4com.puppycrawl.tools.checkstyle.checks.UpperEllCheck	Upper Ell"MINOR*java2Checker/TreeWalker/UpperEll:ÖChecks that long constants are defined with an upper ell. That is ' L' and not 'l'.
    This is in accordance to the Java Language Specification, <a href="http://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html#jls-3.10.1">Section 3.10.1</a>.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3ALowerCaseLongSuffixCheck'>LowerCaseLongSuffixCheck</a> instead.
</p>Z
CODE_SMELL
ó
Kcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.NestedIfDepthCheck«

checkstyle@com.puppycrawl.tools.checkstyle.checks.coding.NestedIfDepthCheckNested If Depth"MAJOR*java2 Checker/TreeWalker/NestedIfDepth:™Restricts nested if-else blocks to a specified depth (default = 1).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS134'>S134</a> instead.
</p>Z
CODE_SMELL
ò
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.ConstantNameCheck…

checkstyle?com.puppycrawl.tools.checkstyle.checks.naming.ConstantNameCheckConstant Name"MINOR*java2Checker/TreeWalker/ConstantName:Æ<p>
Checks that constant names conform to the specified format
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00115'>S00115</a> instead.
</p>@Z
CODE_SMELL
ı
Gcheckstyle:com.puppycrawl.tools.checkstyle.checks.UniquePropertiesCheck©

checkstyle<com.puppycrawl.tools.checkstyle.checks.UniquePropertiesCheckUnique Properties"MAJOR*java2Checker/UniqueProperties:ñ<p>Checks properties file for a duplicated properties.</p>

<p>Rationale: Multiple property keys usualy appears after merge or rebase of several branches. While there is no errors in runtime, there can be a confusion on having different values for the duplicated properties.</p>Z
CODE_SMELL
Í
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.blocks.EmptyBlockCheckù

checkstyle=com.puppycrawl.tools.checkstyle.checks.blocks.EmptyBlockCheckEmpty Block"MAJOR*java2Checker/TreeWalker/EmptyBlock:ä<p>
Checks for empty blocks.
</p>

<p>This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00108'>S00108</a> instead.</p>Z
CODE_SMELL
√
Fcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.TypeNameCheck¯

checkstyle;com.puppycrawl.tools.checkstyle.checks.naming.TypeNameCheck	Type Name"MAJOR*java2Checker/TreeWalker/TypeName:È<p>
Checks that type names conform to the specified format
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00101'>S00101</a> and <a href='/coding_rules#rule_key=squid%3AS00114'>S00114</a> instead.
</p>@Z
CODE_SMELL
î
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck¡

checkstyleCcom.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheckIndentation"MINOR*java2Checker/TreeWalker/Indentation:ßChecks correct indentation of Java Code.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AIndentationCheck'>IndentationCheck</a> instead.
</p>Z
CODE_SMELL
 
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.design.InterfaceIsTypeCheck¯

checkstyleBcom.puppycrawl.tools.checkstyle.checks.design.InterfaceIsTypeCheckInterface Is Type"MAJOR*java2"Checker/TreeWalker/InterfaceIsType:’Implements Bloch, Effective Java, Item 17 - Use Interfaces only to define types.  According to Bloch, an interface should describe a type. It is therefore inappropriate to define an interface that does not contain any methods but only constants. The Standard class javax.swing.SwingConstants is an example of a class that would be flagged by this check. The check can be configured to also disallow marker interfaces like java.io.Serializable, that do not contain methods or constants at all.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1214'>S1214</a> instead.
</p>Z
CODE_SMELL
À
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.HiddenFieldCheck˝

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.HiddenFieldCheckHidden Field"MAJOR*java2Checker/TreeWalker/HiddenField:ÂChecks that a local variable or a parameter does not shadow a field that is defined in the same class.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AHiddenFieldCheck'>HiddenFieldCheck</a> instead.
</p>@Z
CODE_SMELL
Ô
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocMethodCheckû

checkstyleAcom.puppycrawl.tools.checkstyle.checks.javadoc.JavadocMethodCheckJavadoc Method"MAJOR*java2 Checker/TreeWalker/JavadocMethod:ˇChecks the Javadoc of a method or constructor. By default, does not check for unused throws.
    To allow documented java.lang.RuntimeExceptions that are not declared, set property allowUndeclaredRTE to true.
    The scope to verify is specified using the Scope class and defaults to Scope.PRIVATE.
    To verify another scope, set property scope to a different scope.

    <br><br>Error messages about parameters and type parameters for which no param tags are present can be suppressed by defining property allowMissingParamTags.
    Error messages about exceptions which are declared to be thrown, but for which no throws tag is present can be suppressed by defining property allowMissingThrowsTags.
    Error messages about methods which return non-void but for which no return tag is present can be suppressed by defining property allowMissingReturnTag.

    <br><br>Javadoc is not required on a method that is tagged with the @Override annotation.
    However under Java 5 it is not possible to mark a method required for an interface (this was corrected under Java 6).
    Hence Checkstyle supports using the convention of using a single {@inheritDoc} tag instead of all the other tags.

    <br><br>Note that only inheritable items will allow the {@inheritDoc} tag to be used in place of comments.
    Static methods at all visibilities, private non-static methods and constructors are not inheritable.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AUndocumentedApi'>UndocumentedApi</a> instead.
</p>@Z
CODE_SMELL
Â
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.UnnecessaryParenthesesCheckå

checkstyleIcom.puppycrawl.tools.checkstyle.checks.coding.UnnecessaryParenthesesCheckUnnecessary Parentheses"MINOR*java2)Checker/TreeWalker/UnnecessaryParentheses:’Checks if unnecessary parentheses are used in a statement or expression.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AUselessParenthesesCheck'>UselessParenthesesCheck</a> instead.
</p>Z
CODE_SMELL
‰
Zcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.MultipleVariableDeclarationsCheckÖ

checkstyleOcom.puppycrawl.tools.checkstyle.checks.coding.MultipleVariableDeclarationsCheckMultiple Variable Declarations"MAJOR*java2/Checker/TreeWalker/MultipleVariableDeclarations:ªChecks that each variable declaration is in its own statement and on its own line.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1659'>S1659</a> instead.
</p>Z
CODE_SMELL
€
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.FinalLocalVariableCheckÜ

checkstyleEcom.puppycrawl.tools.checkstyle.checks.coding.FinalLocalVariableCheckFinal Local Variable"MINOR*java2%Checker/TreeWalker/FinalLocalVariable:YEnsures that local variables that never get their values changed, must be declared final.@Z
CODE_SMELL
„
Ucheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.MethodTypeParameterNameCheckâ

checkstyleJcom.puppycrawl.tools.checkstyle.checks.naming.MethodTypeParameterNameCheck#Method Type(Generic) Parameter Name"MAJOR*java2*Checker/TreeWalker/MethodTypeParameterName:ƒChecks that method type parameter names conform to the specified format

<p>
The following code snippet illustrates this rule for format "^[A-Z]$":
</p>
<pre>
public &lt;type&gt; boolean containsAll(Collection&lt;type&gt; c) { // Non-compliant
  return null;
}

public &lt;T&gt; boolean containsAll(Collection&lt;T&gt; c) { // Compliant
}
</pre>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00119'>S00119</a> instead.
</p>Z
CODE_SMELL
Ê
Kcheckstyle:com.puppycrawl.tools.checkstyle.checks.design.InnerTypeLastCheckñ

checkstyle@com.puppycrawl.tools.checkstyle.checks.design.InnerTypeLastCheckInner Type Last"INFO*java2 Checker/TreeWalker/InnerTypeLast:{Check nested (internal) classes/interfaces are declared at the bottom of the class after all method and field declarations.Z
CODE_SMELL
Ñ
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.AnonInnerLengthCheck≥

checkstyleAcom.puppycrawl.tools.checkstyle.checks.sizes.AnonInnerLengthCheckAnon Inner Length"MAJOR*java2"Checker/TreeWalker/AnonInnerLength:ëChecks for long anonymous inner classes.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1188'>S1188</a> instead.
</p>Z
CODE_SMELL
Â
Dcheckstyle:com.puppycrawl.tools.checkstyle.checks.header.HeaderCheckú

checkstyle9com.puppycrawl.tools.checkstyle.checks.header.HeaderCheckHeader"MAJOR*java2Checker/Header:°<p>Checks that a source file begins with a specified header. Property headerFile specifies a file that contains the required header. Alternatively, the header specification can be set directly in the header property without the need for an external file.</p>
<p>Property ignoreLines specifies the line numbers to ignore when matching lines in a header file. This property is very useful for supporting headers that contain copyright dates. For example, consider the following header:</p>
<pre>
	line 1: ////////////////////////////////////////////////////////////////////
	line 2: // checkstyle:
	line 3: // Checks Java source code for adherence to a set of rules.
	line 4: // Copyright (C) 2002  Oliver Burn
	line 5: ////////////////////////////////////////////////////////////////////
</pre>
<p>Since the year information will change over time, you can tell Checkstyle to ignore line 4 by setting property ignoreLines to 4.</p>Z
CODE_SMELL
∑
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.NoWhitespaceAfterCheckﬂ

checkstyleHcom.puppycrawl.tools.checkstyle.checks.whitespace.NoWhitespaceAfterCheckNo Whitespace After"MINOR*java2$Checker/TreeWalker/NoWhitespaceAfter:1Checks that there is no whitespace after a token.@Z
CODE_SMELL
Ö
[checkstyle:com.puppycrawl.tools.checkstyle.checks.metrics.ClassDataAbstractionCouplingCheck•

checkstylePcom.puppycrawl.tools.checkstyle.checks.metrics.ClassDataAbstractionCouplingCheckClass Data Abstraction Coupling"MAJOR*java2/Checker/TreeWalker/ClassDataAbstractionCoupling:ZThis metric measures the number of instantiations of other classes within the given class.Z
CODE_SMELL
î
Qcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.OneStatementPerLineCheckæ

checkstyleFcom.puppycrawl.tools.checkstyle.checks.coding.OneStatementPerLineCheckOne Statement Per Line"MAJOR*java2&Checker/TreeWalker/OneStatementPerLine:é<p>
Checks there is only one statement per line. The following line will be flagged as an error: <code>x = 1; y = 2; // Two statments on a single line.</code>
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00122'>S00122</a> instead.
</p>Z
CODE_SMELL
¢
Gcheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.FileLengthCheck÷

checkstyle<com.puppycrawl.tools.checkstyle.checks.sizes.FileLengthCheckFile Length"MAJOR*java2Checker/FileLength:œ<p>Checks for long source files.</p>
<p>Rationale: If a source file becomes very long it is hard to understand. Therefore long classes should usually be refactored into several individual classes that focus on a specific task.</p>

<p>This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00104'>S00104</a> instead.</p>Z
CODE_SMELL
Ù
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.IllegalImportCheck£

checkstyleAcom.puppycrawl.tools.checkstyle.checks.imports.IllegalImportCheckIllegal Import"MAJOR*java2 Checker/TreeWalker/IllegalImport:ÜChecks for imports from a set of illegal packages, like sun.*

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1191'>S1191</a> or <a href='/coding_rules#rule_key=squid%3AArchitecturalConstraint'>ArchitecturalConstraint</a> instead.
</p>Z
CODE_SMELL
»
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.MultipleStringLiteralsCheckÔ

checkstyleIcom.puppycrawl.tools.checkstyle.checks.coding.MultipleStringLiteralsCheckMultiple String Literals"MAJOR*java2)Checker/TreeWalker/MultipleStringLiterals:µChecks for multiple occurrences of the same string literal within a single file. Code duplication makes maintenance more difficult, so it can be better to replace the multiple occurrences with a constant.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1192'>S1192</a> instead.
</p>@Z
CODE_SMELL
≠
Gcheckstyle:com.puppycrawl.tools.checkstyle.checks.blocks.LeftCurlyCheck·

checkstyle<com.puppycrawl.tools.checkstyle.checks.blocks.LeftCurlyCheck
Left Curly"MINOR*java2Checker/TreeWalker/LeftCurly:œChecks for the placement of left curly braces for code blocks. The policy to verify is specified using property option. Policies <code>eol</code> and <code>nlow</code> take into account property maxLineLength.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3ALeftCurlyBraceStartLineCheck'>LeftCurlyBraceStartLineCheck</a> and <a href='/coding_rules#rule_key=squid%3ALeftCurlyBraceEndLineCheck'>LeftCurlyBraceEndLineCheck</a> instead.
</p>@Z
CODE_SMELL
©
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.ParameterNumberCheckÿ

checkstyleAcom.puppycrawl.tools.checkstyle.checks.sizes.ParameterNumberCheckParameter Number"MAJOR*java2"Checker/TreeWalker/ParameterNumber:µ<p>
Checks the number of parameters that a method or constructor has.
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00107'>S00107</a> instead.
</p>@Z
CODE_SMELL
Ï
Kcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.SuperFinalizeCheckú

checkstyle@com.puppycrawl.tools.checkstyle.checks.coding.SuperFinalizeCheckSuper Finalize"MAJOR*java2 Checker/TreeWalker/SuperFinalize:ÄChecks that an overriding finalize() method invokes super.finalize().

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AObjectFinalizeOverridenCallsSuperFinalizeCheck'>ObjectFinalizeOverridenCallsSuperFinalizeCheck</a> instead.
</p>Z
CODE_SMELL
Í
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.design.OneTopLevelClassCheckó

checkstyleCcom.puppycrawl.tools.checkstyle.checks.design.OneTopLevelClassCheckOne Top Level Class"MAJOR*java2#Checker/TreeWalker/OneTopLevelClass:<p>
  Checks that each top-level class, interface or
  enum resides in a source file of its own.
  Official description of a 'top-level' term:<a
  href="http://docs.oracle.com/javase/specs/jls/se8/html/jls-7.html#jls-7.6">7.6. Top Level Type Declarations</a>.
  If file doesn't contains public class, enum or interface,
  top-level type is the first type in file.
</p>Z
CODE_SMELL
ﬂ
Vcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.AbbreviationAsWordInNameCheckÑ

checkstyleKcom.puppycrawl.tools.checkstyle.checks.naming.AbbreviationAsWordInNameCheckAbbreviation As Word In Name"MAJOR*java2+Checker/TreeWalker/AbbreviationAsWordInName:ƒThe Check validate abbreviations(consecutive capital letters) length in identifier name, it also allows to enforce camel case naming. Please read more at <a href="http://google-styleguide.googlecode.com/svn/trunk/javaguide.html#s5.3-camel-case">Google Style Guide</a> to get to know how to avoid long abbreviations in names.Z
CODE_SMELL
ê
Fcheckstyle:com.puppycrawl.tools.checkstyle.checks.TrailingCommentCheck≈

checkstyle;com.puppycrawl.tools.checkstyle.checks.TrailingCommentCheckTrailing Comment"MINOR*java2"Checker/TreeWalker/TrailingComment:™<p>
  The check to ensure that requires that comments be the only thing on a line. For the case of // comments that means that the only thing that should precede it is whitespace. It
  doesn't check comments if they do not end line, i.e. it accept the following: Thread.sleep( 10 &lt;some comment here&gt; ); Format property is intended to deal with the "} //
  while" example.
</p>
<p>
  Rationale: Steve McConnel in "Code Complete" suggests that endline comments are a bad practice. An end line comment would be one that is on the same line as actual code. For
  example:
</p>
<pre>
  <code>
    a = b + c; // Some insightful comment
    d = e / f; // Another comment for this line
  </code>
</pre>

<p>
  Quoting "Code Complete" for the justfication:
</p>
<ul>
  <li>"The comments have to be aligned so that they do not interfere with the visual structure of the code. If you don't align them neatly, they'll make your listing look like it's
    been through a washing machine."
  </li>
  <li>"Endline comments tend to be hard to format...It takes time to align them. Such time is not spent learning more about the code; it's dedicated solely to the tedious task of
    pressing the spacebar or tab key."
  </li>
  <li>"Endline comments are also hard to maintain. If the code on any line containing an endline comment grows, it bumps the comment farther out, and all the other endline comments
    will have to bumped out to match. Styles that are hard to maintain aren't maintained...."
  </li>
  <li>"Endline comments also tend to be cryptic. The right side of the line doesn't offer much room and the desire to keep the comment on one line means the comment must be short.
    Work
    then goes into making the line as short as possible instead of as clear as possible. The comment usually ends up as cryptic as possible...."
  </li>
  <li>"A systemic problem with endline comments is that it's hard to write a meaningful comment for one line of code. Most endline comments just repeat the line of code, which
    hurts
    more than it helps."
  </li>
</ul>
<p>
  His comments on being hard to maintain when the size of the line changes are even more important in the age of automated refactorings.
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3ATrailingCommentCheck'>TrailingCommentCheck</a> instead.
</p>Z
CODE_SMELL
Í
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.InnerAssignmentCheckò

checkstyleBcom.puppycrawl.tools.checkstyle.checks.coding.InnerAssignmentCheckInner Assignment"MAJOR*java2"Checker/TreeWalker/InnerAssignment:ÙChecks for assignments in subexpressions, such as in String s = Integer.toString(i = 2);.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AAssignmentInSubExpressionCheck'>AssignmentInSubExpressionCheck</a> instead.
</p>@Z
CODE_SMELL
∑
Vcheckstyle:com.puppycrawl.tools.checkstyle.checks.indentation.CommentsIndentationCheck‹

checkstyleKcom.puppycrawl.tools.checkstyle.checks.indentation.CommentsIndentationCheckComments Indentation"MINOR*java2&Checker/TreeWalker/CommentsIndentation:©<p>Controls the indentation between comments and surrounding code. Comments are indented at the same level as the surrounding code. Detailed info about such convention can be found <a href="http://checkstyle.sourceforge.net/reports/google-java-style.html#s4.8.6.1-block-comment-style">here</a></p>Z
CODE_SMELL
±
Ocheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.AbstractClassNameCheck›

checkstyleDcom.puppycrawl.tools.checkstyle.checks.naming.AbstractClassNameCheckAbstract Class Name"MAJOR*java2$Checker/TreeWalker/AbstractClassName:¥<p>
Checks that abstract class names conform to the specified format
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00118'>S00118</a> instead.
</p>Z
CODE_SMELL
‰
Qcheckstyle:com.puppycrawl.tools.checkstyle.checks.annotation.MissingOverrideChecké

checkstyleFcom.puppycrawl.tools.checkstyle.checks.annotation.MissingOverrideCheckMissing Override"MAJOR*java2"Checker/TreeWalker/MissingOverride:iVerifies that the java.lang.Override annotation is present when the {@inheritDoc} javadoc tag is present.Z
CODE_SMELL
í
Fcheckstyle:com.puppycrawl.tools.checkstyle.checks.FinalParametersCheck«

checkstyle;com.puppycrawl.tools.checkstyle.checks.FinalParametersCheckFinal Parameters"MINOR*java2"Checker/TreeWalker/FinalParameters:™Check that method/constructor/catch/foreach parameters are final.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1226'>S1226</a> instead.
</p>@Z
CODE_SMELL
ò
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.IllegalTokenTextCheck≈

checkstyleCcom.puppycrawl.tools.checkstyle.checks.coding.IllegalTokenTextCheckIllegal Token Text"MAJOR*java2#Checker/TreeWalker/IllegalTokenText:Checks for illegal token text.@Z
CODE_SMELL
Œ
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.header.RegexpHeaderCheckˇ

checkstyle?com.puppycrawl.tools.checkstyle.checks.header.RegexpHeaderCheckRegexp Header"MAJOR*java2Checker/RegexpHeader:Ò<p>Checks the header of a source file against a header that contains a regular expression for each line of the source header.</p>
	<p>Rationale: In some projects checking against a fixed header is not sufficient, e.g. the header might require a copyright line where the year information is not static. For example, consider the following header:</p>
<pre>
	line  1: ^/{71}$
	line  2: ^// checkstyle:$
	line  3: ^// Checks Java source code for adherence to a set of rules\.$
	line  4: ^// Copyright \(C\) \d\d\d\d  Oliver Burn$
	line  5: ^// Last modification by \$Author.*\$$
	line  6: ^/{71}$
	line  7:
	line  8: ^package
	line  9:
	line 10: ^import
	line 11:
	line 12: ^/\*\*
	line 13: ^ \*([^/]|$)
	line 14: ^ \*/
</pre>
<p>Lines 1 and 6 demonstrate a more compact notation for 71 '/' characters. Line 4 enforces that the copyright notice includes a four digit year. Line 5 is an example how to enforce revision control keywords in a file header. Lines 12-14 is a template for javadoc (line 13 is so complicated to remove conflict with and of javadoc comment).</p>
<p>Different programming languages have different comment syntax rules, but all of them start a comment with a non-word character. Hence you can often use the non-word character class to abstract away the concrete comment syntax and allow checking the header for different languages with a single header definition. For example, consider the following header specification (note that this is not the full Apache license header):</p>
<pre>
	line 1: ^#!
	line 2: ^<\?xml.*>$
	line 3: ^\W*$
	line 4: ^\W*Copyright 2006 The Apache Software Foundation or its licensors, as applicable\.$
	line 5: ^\W*Licensed under the Apache License, Version 2\.0 \(the "License"\);$
	line 6: ^\W*$
</pre>
<p>Lines 1 and 2 leave room for technical header lines, e.g. the "#!/bin/sh" line in Unix shell scripts, or the xml file header of XML files. Set the multiline property to "1, 2" so these lines can be ignored for file types where they do no apply. Lines 3 through 6 define the actual header content. Note how lines 2, 4 and 5 use escapes for characters that have special regexp semantics.</p>
<p>Note: ignoreLines property has been removed from this check to simplify it. To make some line optional use "^.*$" regexp for this line. </p>Z
CODE_SMELL
π
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.EmptyLineSeparatorCheck‡

checkstyleIcom.puppycrawl.tools.checkstyle.checks.whitespace.EmptyLineSeparatorCheckEmpty Line Separator"MAJOR*java2%Checker/TreeWalker/EmptyLineSeparator:ÆChecks for empty line separators after header, package, all import declarations, fields, constructors, methods, nested classes, static initializers and instance initializers.@Z
CODE_SMELL
å
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.ReturnCountCheckæ

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.ReturnCountCheckReturn Count"MAJOR*java2Checker/TreeWalker/ReturnCount:®Restricts return statements to a specified count (default = 2).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1142'>S1142</a> instead.
</p>Z
CODE_SMELL
å
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.design.ThrowsCountCheckæ

checkstyle>com.puppycrawl.tools.checkstyle.checks.design.ThrowsCountCheckThrows Count"MAJOR*java2Checker/TreeWalker/ThrowsCount:®Restricts throws statements to a specified count (default = 1).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1160'>S1160</a> instead.
</p>Z
CODE_SMELL
ï
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.RequireThisCheck«

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.RequireThisCheckRequire This"MAJOR*java2Checker/TreeWalker/RequireThis:2Checks that code doesn't rely on the this default.Z
CODE_SMELL
Í
Ucheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.ExecutableStatementCountCheckê

checkstyleJcom.puppycrawl.tools.checkstyle.checks.sizes.ExecutableStatementCountCheckExecutable Statement Count"MAJOR*java2+Checker/TreeWalker/ExecutableStatementCount:RRestricts the number of executable statements to a specified limit (default = 30).@Z
CODE_SMELL
°
Ucheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.AvoidInlineConditionalsCheck«

checkstyleJcom.puppycrawl.tools.checkstyle.checks.coding.AvoidInlineConditionalsCheckAvoid Inline Conditionals"MINOR*java2*Checker/TreeWalker/AvoidInlineConditionals:å<p>Detects inline conditionals.</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1774'>S1774</a> instead.
</p>Z
CODE_SMELL
Æ
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.SimplifyBooleanReturnCheck÷

checkstyleHcom.puppycrawl.tools.checkstyle.checks.coding.SimplifyBooleanReturnCheckSimplify Boolean Return"MAJOR*java2(Checker/TreeWalker/SimplifyBooleanReturn:°Checks for overly complicated boolean return statements.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1126'>S1126</a> instead.
</p>Z
CODE_SMELL
¨
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.MethodParamPadCheck◊

checkstyleEcom.puppycrawl.tools.checkstyle.checks.whitespace.MethodParamPadCheckMethod Param Pad"MAJOR*java2!Checker/TreeWalker/MethodParamPad:±Checks the padding between the identifier of a method definition, constructor definition, method call, or constructor invocation; and the left parenthesis of the parameter list.@Z
CODE_SMELL
 
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.CovariantEqualsCheck¯

checkstyleBcom.puppycrawl.tools.checkstyle.checks.coding.CovariantEqualsCheckCovariant Equals"CRITICAL*java2"Checker/TreeWalker/CovariantEquals:”Checks that if a class defines a covariant method equals, then it defines method equals(java.lang.Object).

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1201'>S1201</a> instead.
</p>Z
CODE_SMELL
õ
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.AvoidStarImportCheck»

checkstyleCcom.puppycrawl.tools.checkstyle.checks.imports.AvoidStarImportCheckAvoid Star Import"MINOR*java2"Checker/TreeWalker/AvoidStarImport:§Check that finds import statements that use the * notation.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS2208'>S2208</a> instead.
</p>Z
CODE_SMELL
∞
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.StaticVariableNameCheck€

checkstyleEcom.puppycrawl.tools.checkstyle.checks.naming.StaticVariableNameCheckStatic Variable Name"MAJOR*java2%Checker/TreeWalker/StaticVariableName:≠Checks that static, non-final fields conform to the specified format

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS3008'>S3008</a> instead.
</p>@Z
CODE_SMELL
…
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.design.MutableExceptionCheckˆ

checkstyleCcom.puppycrawl.tools.checkstyle.checks.design.MutableExceptionCheckMutable Exception"MAJOR*java2#Checker/TreeWalker/MutableException:—Ensures that exceptions (defined as any class name conforming to some regular expression) are immutable.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1165'>S1165</a> instead.
</p>Z
CODE_SMELL
æ
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.NoFinalizerCheck

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.NoFinalizerCheckNo Finalizer"MAJOR*java2Checker/TreeWalker/NoFinalizer:⁄<p>Verifies there are no finalize() methods defined in a class.</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AObjectFinalizeOverridenCheck'>ObjectFinalizeOverridenCheck</a> instead.
</p>Z
CODE_SMELL
Ë
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.ParenPadCheckô

checkstyle?com.puppycrawl.tools.checkstyle.checks.whitespace.ParenPadCheck	Paren Pad"MINOR*java2Checker/TreeWalker/ParenPad:ÜChecks the padding of parentheses; that is whether a space is required after a left parenthesis and before a right parenthesis, or such spaces are forbidden, with the exception that it does not check for padding of the right parenthesis at an empty for iterator.@Z
CODE_SMELL
õ
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.MemberNameCheckŒ

checkstyle=com.puppycrawl.tools.checkstyle.checks.naming.MemberNameCheckMember name"MAJOR*java2Checker/TreeWalker/MemberName:π<p>
Checks that name of non-static fields conform to the specified format
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00116'>S00116</a> instead.
</p>@Z
CODE_SMELL
î
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.design.FinalClassCheck«

checkstyle=com.puppycrawl.tools.checkstyle.checks.design.FinalClassCheckFinal Class"MAJOR*java2Checker/TreeWalker/FinalClass:¥Checks that class which has only private constructors is declared as final.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS2974'>S2974</a> instead.
</p>Z
CODE_SMELL
í
Kcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.ParameterNameCheck¬

checkstyle@com.puppycrawl.tools.checkstyle.checks.naming.ParameterNameCheckParameter Name"MAJOR*java2 Checker/TreeWalker/ParameterName:¶Checks that parameter names conform to the specified format

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00117'>S00117</a> instead.
</p>Z
CODE_SMELL
Î
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.ImportControlCheckö

checkstyleAcom.puppycrawl.tools.checkstyle.checks.imports.ImportControlCheckImport Control"BLOCKER*java2 Checker/TreeWalker/ImportControl:˚<p>Controls what can be imported in each package.
Useful for ensuring that application layering rules are not violated, especially on large projects.</p>

<p>The DTD for a import control XML document is at <a href="http://www.puppycrawl.com/dtds/import_control_1_1.dtd"
target="_blank">http://www.puppycrawl.com/dtds/import_control_1_1.dtd</a>. It contains documentation on each of the
elements and attributes.</p>

<p>The check validates a XML document when it loads the document. To validate against the above DTD, include the
following document type declaration in your XML document:</p>

<pre>&lt;!DOCTYPE import-control PUBLIC
    "-//Puppy Crawl//DTD Import Control 1.1//EN"
    "http://www.puppycrawl.com/dtds/import_control_1_1.dtd"&gt;</pre>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AArchitecturalConstraint'>ArchitecturalConstraint</a> instead.
</p>Z
CODE_SMELL
Ê
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.MagicNumberCheckò

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.MagicNumberCheckMagic Number"MINOR*java2Checker/TreeWalker/MagicNumber:ÄChecks for magic numbers.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS109'>S109</a> instead.
</p>@Z
CODE_SMELL
–
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.MissingSwitchDefaultCheck˘

checkstyleGcom.puppycrawl.tools.checkstyle.checks.coding.MissingSwitchDefaultCheckMissing Switch Default"MAJOR*java2'Checker/TreeWalker/MissingSwitchDefault:«Checks that switch statement has default clause.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3ASwitchLastCaseIsDefaultCheck'>SwitchLastCaseIsDefaultCheck</a> instead.
</p>Z
CODE_SMELL
·
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.annotation.SuppressWarningsCheckä

checkstyleGcom.puppycrawl.tools.checkstyle.checks.annotation.SuppressWarningsCheckSuppress Warnings"MAJOR*java2#Checker/TreeWalker/SuppressWarnings:ﬂ<p> This check allows you to specify what warnings that SuppressWarnings is not allowed to suppress. You can also specify a list of TokenTypes that the configured warning(s) cannot be suppressed on.</p>
<p>Limitations: This check does not consider conditionals inside the SuppressWarnings annotation.
For example: @SupressWarnings((false) ? (true) ? "unchecked" : "foo" : "unused") According to the above example, the "unused" warning is being suppressed not the "unchecked" or "foo" warnings. All of these warnings will be considered and matched against regardless of what the conditional evaluates to.</p>@Z
CODE_SMELL
ö
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.metrics.NPathComplexityCheck«

checkstyleCcom.puppycrawl.tools.checkstyle.checks.metrics.NPathComplexityCheckNPath Complexity"MAJOR*java2"Checker/TreeWalker/NPathComplexity:§Checks the npath complexity of a method against a specified limit (default = 200). The NPATH metric computes the number of possible execution paths through a function. It takes into account the nesting of conditional statements and multi-part boolean expressions (e.g., A && B, C || D, etc.).Z
CODE_SMELL
Å
^checkstyle:com.puppycrawl.tools.checkstyle.checks.coding.VariableDeclarationUsageDistanceCheckû

checkstyleScom.puppycrawl.tools.checkstyle.checks.coding.VariableDeclarationUsageDistanceCheck#Variable Declaration Usage Distance"MAJOR*java23Checker/TreeWalker/VariableDeclarationUsageDistance:HChecks the distance between declaration of variable and its first usage.Z
CODE_SMELL
‡
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.CustomImportOrderCheckã

checkstyleEcom.puppycrawl.tools.checkstyle.checks.imports.CustomImportOrderCheckCustom Import Order"MAJOR*java2$Checker/TreeWalker/CustomImportOrder:·<p>
          Checks that the groups of import declarations appear in the order specified
          by the user. If there is an import but its group is not specified in the
          configuration such an import should be placed at the end of the import list.
        </p>

        <p>
          The rule consists of:
        </p>
        <p>
         1) STATIC group. This group sets the ordering of static imports.
        </p>
        <p>
          2) SAME_PACKAGE(n) group. This group sets the ordering of the same package imports.
          n' - a number of the first package domains. For example:
        </p>
        <pre>
 package java.util.concurrent;

 import java.util.regex.Pattern;
 import java.util.List;
 import java.util.StringTokenizer;
 import java.util.regex.Pattern;
 import java.util.*;
 import java.util.concurrent.AbstractExecutorService;
 import java.util.concurrent.*;
        </pre>
        <p>
          And we have such configuration: SAME_PACKAGE (3).
          Same package imports are java.util.*, java.util.concurrent.*,
          java.util.concurrent.AbstractExecutorService,
          java.util.List and java.util.StringTokenizer
        </p>
        <p>
          3) THIRD_PARTY_PACKAGE group. This group sets ordering of third party imports.
          Third party imports are all imports except STATIC,
          SAME_PACKAGE(n) and STANDARD_JAVA_PACKAGE.
        </p>
        <p>
          4) STANDARD_JAVA_PACKAGE group. This group sets ordering of standard java (java|javax) imports.
        </p>
        <p>
          5) SPECIAL_IMPORTS group. This group may contains some imports
          that have particular meaning for the user.
        </p>

        <p>
          Use the separator '###' between rules.
        </p>Z
CODE_SMELL
Ì
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.NewlineAtEndOfFileCheckü

checkstyle>com.puppycrawl.tools.checkstyle.checks.NewlineAtEndOfFileCheckNewline At End Of File"MINOR*java2Checker/NewlineAtEndOfFile:É<p>
Checks that there is a newline at the end of each file. Any source files and text files in general should end with a newline character, especially when using SCM systems such as CVS. CVS will even print a warning when it encounters a file that doesn't end with a newline.
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00113'>S00113</a> instead.
</p>Z
CODE_SMELL
À
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.MissingCtorCheck˝

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.MissingCtorCheckMissing Constructor"MAJOR*java2Checker/TreeWalker/MissingCtor:aChecks that classes (except abstract one) define a constructor and don't rely on the default one.Z
CODE_SMELL
±
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.design.DesignForExtensionCheck‹

checkstyleEcom.puppycrawl.tools.checkstyle.checks.design.DesignForExtensionCheckDesign For Extension"MINOR*java2%Checker/TreeWalker/DesignForExtension:1Checks that classes are designed for inheritance.Z
CODE_SMELL
‘
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.DefaultComesLastCheckÅ

checkstyleCcom.puppycrawl.tools.checkstyle.checks.coding.DefaultComesLastCheckDefault Comes Last"MAJOR*java2#Checker/TreeWalker/DefaultComesLast:€Check that the default is after all the cases in a switch statement.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3ASwitchLastCaseIsDefaultCheck'>SwitchLastCaseIsDefaultCheck</a> instead.
</p>Z
CODE_SMELL
„
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.OuterTypeFilenameCheckñ

checkstyle=com.puppycrawl.tools.checkstyle.checks.OuterTypeFilenameCheckOuter Type Filename"MAJOR*java2$Checker/TreeWalker/OuterTypeFilename:uChecks that the outer type name and the file name match. For example, the class Foo must be in a file named Foo.java.Z
CODE_SMELL
Ú
Echeckstyle:com.puppycrawl.tools.checkstyle.checks.ArrayTypeStyleCheck®

checkstyle:com.puppycrawl.tools.checkstyle.checks.ArrayTypeStyleCheckArray Type Style"MINOR*java2!Checker/TreeWalker/ArrayTypeStyle:èChecks the style of array type definitions. Some like Java-style: public static void main(String[] args) and some like C-style: public static void main(String args[])

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1197'>S1197</a> instead.
</p>Z
CODE_SMELL
í
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.blocks.EmptyCatchBlockCheck¿

checkstyleBcom.puppycrawl.tools.checkstyle.checks.blocks.EmptyCatchBlockCheckEmpty catch block"MAJOR*java2'Checker/TreeWalker/EmptyCatchBlockCheck:òChecks for empty catch blocks. There are two options to make validation more precise (by default Check allows empty catch block with any comment inside)Z
CODE_SMELL
Â
Xcheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.InterfaceTypeParameterNameCheckà

checkstyleMcom.puppycrawl.tools.checkstyle.checks.naming.InterfaceTypeParameterNameCheckInterface Type Parameter Name"MAJOR*java2-Checker/TreeWalker/InterfaceTypeParameterName:D<p>
Checks that interface names conform to the specified format
</p>Z
CODE_SMELL
‡
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.StringLiteralEqualityCheckà

checkstyleHcom.puppycrawl.tools.checkstyle.checks.coding.StringLiteralEqualityCheckString Literal Equality"CRITICAL*java2(Checker/TreeWalker/StringLiteralEquality:–Checks that string literals are not used with == or !=.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AStringEqualityComparisonCheck'>StringEqualityComparisonCheck</a> instead.
</p>Z
CODE_SMELL
„
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.ImportOrderCheckî

checkstyle?com.puppycrawl.tools.checkstyle.checks.imports.ImportOrderCheckImport Order"MINOR*java2Checker/TreeWalker/ImportOrder:˝Checks the ordering/grouping of imports. Features are:<ul>
    <li>groups imports: ensures that groups of imports come in a specific order (e.g., java. comes first, javax. comes second, then everything else)</li>
    <li>adds a separation between groups : ensures that a blank line sit between each group</li>
    <li>sorts imports inside each group: ensures that imports within each group are in lexicographic order</li>
    <li>sorts according to case: ensures that the comparison between imports is case sensitive</li>
    <li>groups static imports: ensures the relative order between regular imports and static imports</li>
    </ul>Z
CODE_SMELL
ä
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.FileTabCharacterCheck≥

checkstyleGcom.puppycrawl.tools.checkstyle.checks.whitespace.FileTabCharacterCheckFile Tab Character"MINOR*java2Checker/FileTabCharacter:î<p>Checks that there are no tab characters ('\t') in the source code. Rationale:
<ul>
    <li>Developers should not need to configure the tab width of their text editors in order to be able to read source code.</li>
    <li>From the Apache jakarta coding standards: In a distributed development environment, when the commit messages get sent to a mailing list, they are almost impossible to read if you use tabs.</li>
</ul></p>

<p>This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00105'>S00105</a> instead.</p>Z
CODE_SMELL
¬
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.design.VisibilityModifierCheckÌ

checkstyleEcom.puppycrawl.tools.checkstyle.checks.design.VisibilityModifierCheckVisibility Modifier"MAJOR*java2%Checker/TreeWalker/VisibilityModifier:¬Checks visibility of class members. Only static final members may be public; other class members must be private unless property protectedAllowed or packageAllowed is set.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AClassVariableVisibilityCheck'>ClassVariableVisibilityCheck</a> instead.
</p>Z
CODE_SMELL
‡
Gcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.WriteTagCheckî

checkstyle<com.puppycrawl.tools.checkstyle.checks.javadoc.WriteTagCheck	Write Tag"MINOR*java2Checker/TreeWalker/WriteTag:ÜOutputs a JavaDoc tag as information. Can be used e.g. with the stylesheets that sort the report by author name. To define the format for a tag, set property tagFormat to a regular expression. This check uses two different severity levels. The normal one is used for reporting when the tag is missing. The additional one (tagSeverity) is used for the level of reporting when the tag exists.Z
CODE_SMELL
·
Icheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.FallThroughCheckì

checkstyle>com.puppycrawl.tools.checkstyle.checks.coding.FallThroughCheckFall Through"MAJOR*java2Checker/TreeWalker/FallThrough:˝Checks for fall through in switch statements Finds locations where a case contains Java code - but lacks a break, return, throw or continue statement.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS128'>S128</a> instead.
</p>Z
CODE_SMELL
∏
Wcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.SimplifyBooleanExpressionCheck‹

checkstyleLcom.puppycrawl.tools.checkstyle.checks.coding.SimplifyBooleanExpressionCheckSimplify Boolean Expression"MAJOR*java2,Checker/TreeWalker/SimplifyBooleanExpression:õChecks for overly complicated boolean expressions.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1125'>S1125</a> instead.
</p>Z
CODE_SMELL
©
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.EmptyStatementCheckÿ

checkstyleAcom.puppycrawl.tools.checkstyle.checks.coding.EmptyStatementCheckEmpty Statement"MINOR*java2!Checker/TreeWalker/EmptyStatement:πDetects empty statements (standalone ';').

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AEmptyStatementUsageCheck'>EmptyStatementUsageCheck</a> instead.
</p>Z
CODE_SMELL
Ì
Ucheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.EmptyForIteratorPadCheckì

checkstyleJcom.puppycrawl.tools.checkstyle.checks.whitespace.EmptyForIteratorPadCheckEmpty For Iterator Pad"MINOR*java2&Checker/TreeWalker/EmptyForIteratorPad:ﬂChecks the padding of an empty for iterator; that is whether a space is required at an empty for iterator, or such spaces are forbidden. Example : <code>for (Iterator foo = very.long.line.iterator(); foo.hasNext(); )</code>Z
CODE_SMELL
¿
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.ArrayTrailingCommaCheckÎ

checkstyleEcom.puppycrawl.tools.checkstyle.checks.coding.ArrayTrailingCommaCheckArray Trailing Comma"MAJOR*java2%Checker/TreeWalker/ArrayTrailingComma:@Checks if array initialization contains optional trailing comma.Z
CODE_SMELL
•
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.OperatorWrapCheck“

checkstyleCcom.puppycrawl.tools.checkstyle.checks.whitespace.OperatorWrapCheckOperator Wrap"MINOR*java2Checker/TreeWalker/OperatorWrap:4Checks the policy on how to wrap lines on operators.@Z
CODE_SMELL
˛
`checkstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocTagContinuationIndentationCheckô

checkstyleUcom.puppycrawl.tools.checkstyle.checks.javadoc.JavadocTagContinuationIndentationCheck$Javadoc Tag Continuation Indentation"MAJOR*java24Checker/TreeWalker/JavadocTagContinuationIndentation:?Checks the indentation of the continuation lines in at-clauses.Z
CODE_SMELL
Ø
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.SingleLineJavadocCheck⁄

checkstyleEcom.puppycrawl.tools.checkstyle.checks.javadoc.SingleLineJavadocCheckSingle Line Javadoc"MAJOR*java2$Checker/TreeWalker/SingleLineJavadoc:∞Checks that a JavaDoc block which can fit on a single line and doesn't contain at-clauses. Javadoc comment that contains at leat one at-clause should be formatted in few lines.Z
CODE_SMELL
à
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.SuperCloneCheckª

checkstyle=com.puppycrawl.tools.checkstyle.checks.coding.SuperCloneCheckSuper Clone"MAJOR*java2Checker/TreeWalker/SuperClone:®Checks that an overriding clone() method invokes super.clone().

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1182'>S1182</a> instead.
</p>Z
CODE_SMELL
ÿ
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.imports.RedundantImportCheckÖ

checkstyleCcom.puppycrawl.tools.checkstyle.checks.imports.RedundantImportCheckRedundant import"MINOR*java2"Checker/TreeWalker/RedundantImport:‚Checks for redundant import statements. An import statement is considered redundant if:
<ul>
    <li>It is a duplicate of another import. This is, when a class is imported more than once.</li>
    <li>The class imported is from the java.lang package, e.g. importing java.lang.String.</li>
    <li>The class imported is from the same package.</li></ul>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AUselessImportCheck'>UselessImportCheck</a> instead.
</p>Z
CODE_SMELL
˘
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.AvoidEscapedUnicodeCharactersCheck†

checkstyleIcom.puppycrawl.tools.checkstyle.checks.AvoidEscapedUnicodeCharactersCheck Avoid Escaped Unicode Characters"MAJOR*java20Checker/TreeWalker/AvoidEscapedUnicodeCharacters:Ÿ<p>
  Restrict using <a href = "http://docs.oracle.com/javase/specs/jls/se8/html/jls-3.html#jls-3.3">
  Unicode escapes</a> (e.g. \u221e).
  It is possible to allow using escapes for
  <a href="http://en.wiktionary.org/wiki/Appendix:Control_characters"> non-printable(control) characters</a>.
  Also, this check can be configured to allow using escapes
  if trail comment is present. By the option it is possible to
  allow using escapes if literal contains only them.
</p>Z
CODE_SMELL
ú
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.OuterTypeNumberCheckÀ

checkstyleAcom.puppycrawl.tools.checkstyle.checks.sizes.OuterTypeNumberCheckOuter Type Number"MINOR*java2"Checker/TreeWalker/OuterTypeNumber:©<p> Checks for the number of types declared at the outer (or root) level in a file. Rationale: It is considered good practice to only define one outer type per file.</p>Z
CODE_SMELL
Ü
Fcheckstyle:com.puppycrawl.tools.checkstyle.checks.UncommentedMainCheckª

checkstyle;com.puppycrawl.tools.checkstyle.checks.UncommentedMainCheckUncommented Main"MAJOR*java2"Checker/TreeWalker/UncommentedMain:!Detects uncommented main methods.Z
CODE_SMELL
ì
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.annotation.MissingDeprecatedCheckª

checkstyleHcom.puppycrawl.tools.checkstyle.checks.annotation.MissingDeprecatedCheckMissing Deprecated"MAJOR*java2$Checker/TreeWalker/MissingDeprecated:èVerifies that both the java.lang.Deprecated annotation is present and the @deprecated Javadoc tag is present when either is present.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AMissingDeprecatedCheck'>MissingDeprecatedCheck</a> instead.
</p>Z
CODE_SMELL
√
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.modifier.ModifierOrderCheckÒ

checkstyleBcom.puppycrawl.tools.checkstyle.checks.modifier.ModifierOrderCheckModifier Order"MINOR*java2 Checker/TreeWalker/ModifierOrder:”Checks that the order of modifiers conforms to the suggestions in the <a href="http://docs.oracle.com/javase/specs/jls/se8/html/jls-8.html">Java Language specification, sections 8.1.1, 8.3.1 and 8.4.3</a>. The correct order is : public, protected, private, abstract, static, final, transient, volatile, synchronized, native, strictfp.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AModifiersOrderCheck'>ModifiersOrderCheck</a> instead.
</p>Z
CODE_SMELL
Ÿ
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.IllegalTokenCheckä

checkstyle?com.puppycrawl.tools.checkstyle.checks.coding.IllegalTokenCheckIllegal Token"MAJOR*java2Checker/TreeWalker/IllegalToken:ÔChecks for illegal tokens. Certain language features often lead to hard to maintain code or are non-obvious to novice developers. Other features may be discouraged in certain frameworks, such as not having native methods in EJB components.@Z
CODE_SMELL
≠
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.metrics.ClassFanOutComplexityCheck‘

checkstyleIcom.puppycrawl.tools.checkstyle.checks.metrics.ClassFanOutComplexityCheckClass Fan Out Complexity"MAJOR*java2(Checker/TreeWalker/ClassFanOutComplexity:ùThe number of other classes a given class relies on.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1200'>S1200</a> instead.
</p>Z
CODE_SMELL
ÿ
Xcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.EmptyForInitializerPadCheck˚

checkstyleMcom.puppycrawl.tools.checkstyle.checks.whitespace.EmptyForInitializerPadCheckEmpty For Initializer Pad"MINOR*java2)Checker/TreeWalker/EmptyForInitializerPad:æChecks the padding of an empty for initializer; that is whether a space is required at an empty for initializer, or such spaces are forbidden. Example : <code>for ( ; i < j; i++, j--)</code>Z
CODE_SMELL
É
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.regexp.RegexpSinglelineCheck∞

checkstyleCcom.puppycrawl.tools.checkstyle.checks.regexp.RegexpSinglelineCheckRegexp Singleline"MAJOR*java2Checker/RegexpSingleline:î<p> A check for detecting single lines that match a supplied regular expression. Works with any file type. Rationale: This check can be used to prototype checks and to find common bad practice such as calling ex.printStacktrace(), System.out.println(), System.exit(), etc.</p>@Z
CODE_SMELL
à
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.regexp.RegexpMultilineCheck∂

checkstyleBcom.puppycrawl.tools.checkstyle.checks.regexp.RegexpMultilineCheckRegexp Multiline"MAJOR*java2Checker/RegexpMultiline:ù<p>A check for detecting that matches across multiple lines. Rationale: This check can be used to when the regular expression can be span multiple lines.</p>@Z
CODE_SMELL
ì
Qcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.WhitespaceAfterCheckΩ

checkstyleFcom.puppycrawl.tools.checkstyle.checks.whitespace.WhitespaceAfterCheckWhitespace After"MINOR*java2"Checker/TreeWalker/WhitespaceAfter:ïChecks that a token is followed by whitespace, with the exception that it does not check for whitespace after the semicolon of an empty for iterator.@Z
CODE_SMELL
Œ
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.IllegalCatchCheckˇ

checkstyle?com.puppycrawl.tools.checkstyle.checks.coding.IllegalCatchCheckIllegal Catch"MAJOR*java2Checker/TreeWalker/IllegalCatch:gCatching java.lang.Exception, java.lang.Error or java.lang.RuntimeException is almost never acceptable.Z
CODE_SMELL
©
Kcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.IllegalThrowsCheckŸ

checkstyle@com.puppycrawl.tools.checkstyle.checks.coding.IllegalThrowsCheckIllegal Throws"MAJOR*java2 Checker/TreeWalker/IllegalThrows:ΩThrowing java.lang.Error or java.lang.RuntimeException is almost never acceptable.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00112'>S00112</a> instead.
</p>Z
CODE_SMELL
Á
]checkstyle:com.puppycrawl.tools.checkstyle.checks.coding.OverloadMethodsDeclarationOrderCheckÖ

checkstyleRcom.puppycrawl.tools.checkstyle.checks.coding.OverloadMethodsDeclarationOrderCheck"Overload Methods Declaration Order"MAJOR*java22Checker/TreeWalker/OverloadMethodsDeclarationOrder:2Checks that overload methods are grouped together.Z
CODE_SMELL
ç
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.AtclauseOrderCheckº

checkstyleAcom.puppycrawl.tools.checkstyle.checks.javadoc.AtclauseOrderCheckAt-clause Order"MAJOR*java2 Checker/TreeWalker/AtclauseOrder:Checks the order of at-clauses.Z
CODE_SMELL
û
Jcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocTypeCheckœ

checkstyle?com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocTypeCheckJavadoc Type"MAJOR*java2Checker/TreeWalker/JavadocType:∂Checks Javadoc comments for class and interface definitions. By default, does not check for author or version tags.
    The scope to verify is specified using the Scope class and defaults to Scope.PRIVATE. To verify another scope, set property scope to one of the Scope constants.
    To define the format for an author tag or a version tag, set property authorFormat or versionFormat respectively to a regular expression.
    <br><br>Error messages about type parameters for which no param tags are present can be suppressed by defining property allowMissingParamTags.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AUndocumentedApi'>UndocumentedApi</a> instead.
</p>@Z
CODE_SMELL
æ
Ocheckstyle:com.puppycrawl.tools.checkstyle.checks.naming.LocalVariableNameCheckÍ

checkstyleDcom.puppycrawl.tools.checkstyle.checks.naming.LocalVariableNameCheckLocal Variable Name"MAJOR*java2$Checker/TreeWalker/LocalVariableName:ø<p>
Checks that local, non-final variable names conform to the specified format
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00117'>S00117</a> instead.
</p>@Z
CODE_SMELL
≤
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.whitespace.TypecastParenPadCheck€

checkstyleGcom.puppycrawl.tools.checkstyle.checks.whitespace.TypecastParenPadCheckTypecast Paren Pad"MAJOR*java2#Checker/TreeWalker/TypecastParenPad:0Checks the padding of parentheses for typecasts.@Z
CODE_SMELL
Ê
Gcheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheckö

checkstyle<com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheckLine Length"MAJOR*java2Checker/TreeWalker/LineLength:à<p>
Checks for long lines.
</p>

<p>This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS00103'>S00103</a> instead.</p>Z
CODE_SMELL
ê
Pcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.PackageDeclarationCheckª

checkstyleEcom.puppycrawl.tools.checkstyle.checks.coding.PackageDeclarationCheckPackage Declaration"MAJOR*java2%Checker/TreeWalker/PackageDeclaration:êEnsures there is a package declaration.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1220'>S1220</a> instead.
</p>Z
CODE_SMELL
·
Zcheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.NonEmptyAtclauseDescriptionCheckÇ

checkstyleOcom.puppycrawl.tools.checkstyle.checks.javadoc.NonEmptyAtclauseDescriptionCheckNon Empty At-clause Description"MAJOR*java2.Checker/TreeWalker/NonEmptyAtclauseDescription:9Checks that the at-clause tag is followed by description.Z
CODE_SMELL
˘
Ocheckstyle:com.puppycrawl.tools.checkstyle.checks.blocks.AvoidNestedBlocksCheck•

checkstyleDcom.puppycrawl.tools.checkstyle.checks.blocks.AvoidNestedBlocksCheckAvoid Nested Blocks"MAJOR*java2$Checker/TreeWalker/AvoidNestedBlocks:}Finds nested blocks.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1199'>S1199</a> instead.
</p>Z
CODE_SMELL
Ç
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.sizes.MethodCountCheckµ

checkstyle=com.puppycrawl.tools.checkstyle.checks.sizes.MethodCountCheckMethod Count"MAJOR*java2Checker/TreeWalker/MethodCount:†Checks the number of methods declared in each type. This includes the number of each scope (private, package, protected and public) as well as an overall total.Z
CODE_SMELL
•
Bcheckstyle:com.puppycrawl.tools.checkstyle.checks.TodoCommentCheckﬁ

checkstyle7com.puppycrawl.tools.checkstyle.checks.TodoCommentCheckComment pattern matcher"MINOR*java2Checker/TreeWalker/TodoComment:¬This rule allows to find any kind of pattern inside comments like TODO, NOPMD, ..., except NOSONAR

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1135'>S1135</a>, <a href='/coding_rules#rule_key=squid%3AS1310'>S1310</a> and <a href='/coding_rules#rule_key=squid%3AS1315'>S1315</a> instead.
</p>@Z
CODE_SMELL
…
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.DeclarationOrderCheckˆ

checkstyleCcom.puppycrawl.tools.checkstyle.checks.coding.DeclarationOrderCheckDeclaration Order"INFO*java2#Checker/TreeWalker/DeclarationOrder:“Checks that the parts of a class or interface declaration appear in the order suggested by the Code Convention for the Java Programming Language : <ul><li>Class (static) variables. First the public class variables, then the protected, then package level (no access modifier), and then the private.</li><li>Instance variables. First the public class variables, then the protected, then package level (no access modifier), and then the private.</li><li>Constructors</li><li>Methods</li></ul>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1213'>S1213</a> instead.
</p>Z
CODE_SMELL
π
Tcheckstyle:com.puppycrawl.tools.checkstyle.checks.annotation.AnnotationUseStyleCheck‡

checkstyleIcom.puppycrawl.tools.checkstyle.checks.annotation.AnnotationUseStyleCheckAnnotation Use Style"MAJOR*java2%Checker/TreeWalker/AnnotationUseStyle:1Controls the style with the usage of annotations.Z
CODE_SMELL
ö
Lcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.EqualsHashCodeCheck…

checkstyleAcom.puppycrawl.tools.checkstyle.checks.coding.EqualsHashCodeCheckEquals Hash Code"CRITICAL*java2!Checker/TreeWalker/EqualsHashCode:≠Checks that classes that override equals() also override hashCode().

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1206'>S1206</a> instead.
</p>ZBUG
—
Gcheckstyle:com.puppycrawl.tools.checkstyle.checks.metrics.JavaNCSSCheckÖ

checkstyle<com.puppycrawl.tools.checkstyle.checks.metrics.JavaNCSSCheckJavaNCSS"MAJOR*java2Checker/TreeWalker/JavaNCSS:¯Determines complexity of methods, classes and files by counting the Non Commenting Source Statements (NCSS). This check adheres to the  specification for the JavaNCSS-Tool  written by Chr. Clemens Lee.
Rougly said the NCSS metric is calculated by counting the source lines which are not comments, (nearly) equivalent to counting the semicolons and opening curly braces.
The NCSS for a class is summarized from the NCSS of all its methods, the NCSS of its nested classes and the number of member variable declarations.
The NCSS for a file is summarized from the ncss of all its top level classes, the number of imports and the package declaration.
<br>
Rationale: Too large methods and classes are hard to read and costly to maintain. A large NCSS number often means that a method or class has too many responsabilities and/or functionalities which should be decomposed into smaller units.Z
CODE_SMELL
è
Qcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.ParameterAssignmentCheckπ

checkstyleFcom.puppycrawl.tools.checkstyle.checks.coding.ParameterAssignmentCheckParameter Assignment"MAJOR*java2&Checker/TreeWalker/ParameterAssignment:ãDisallow assignment of parameters.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1226'>S1226</a> instead.
</p>Z
CODE_SMELL
Á
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.annotation.PackageAnnotationCheckè

checkstyleHcom.puppycrawl.tools.checkstyle.checks.annotation.PackageAnnotationCheckPackage Annotation"MINOR*java2$Checker/TreeWalker/PackageAnnotation:„<p>This check makes sure that all package annotations are in the package-info.java file.</p>
<p>According to the Java JLS 3rd ed.</p>
<p>The JLS does not enforce the placement of package annotations. This placement may vary based on implementation. The JLS does highly recommend that all package annotations are placed in the package-info.java file. See <a href="http://java.sun.com/docs/books/jls/third_edition/html/j3TOC.html">Java Language specification, sections 7.4.1.1</a>.</p>Z
CODE_SMELL
†
Ncheckstyle:com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocVariableCheckÕ

checkstyleCcom.puppycrawl.tools.checkstyle.checks.javadoc.JavadocVariableCheckJavadoc Variable"MAJOR*java2"Checker/TreeWalker/JavadocVariable:®Checks that a variable has Javadoc comment.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AUndocumentedApi'>UndocumentedApi</a> instead.
</p>@Z
CODE_SMELL
Œ
Mcheckstyle:com.puppycrawl.tools.checkstyle.checks.coding.EqualsAvoidNullCheck¸

checkstyleBcom.puppycrawl.tools.checkstyle.checks.coding.EqualsAvoidNullCheckEquals Avoid Null"MAJOR*java2"Checker/TreeWalker/EqualsAvoidNull:Ÿ<p>Checks that any combination of String literals with optional assignment is on the left side of an equals() comparison.</p>
<p>Rationale: Calling the equals() method on String literals will avoid a potential NullPointerException. Also, it is pretty common to see null check right before equals comparisons which is not necessary in the below example.</p>
<p>For example:
<pre>
  String nullString = null;
  nullString.equals("My_Sweet_String");
</pre>
</p>

<p>
should be refactored to:
<pre>
  String nullString = null;
  "My_Sweet_String".equals(nullString);
</pre>
</p>
<p>Limitations: If the equals method is overridden or a covariant equals method is defined and the implementation is incorrect (where s.equals(t) does not return the same result as t.equals(s)) then rearranging the called on object and parameter may have unexpected results.</p>
<p>Java's Autoboxing feature has an affect on how this check is implemented. Pre Java 5 all IDENT + IDENT object concatenations would not cause a NullPointerException even if null. Those situations could have been included in this check. They would simply act as if they surrounded by String.valueof() which would concatenate the String null.</p>
<p>The following example will cause a NullPointerException as a result of what autoboxing does.</p>
<pre>
  Integer i = null, j = null;
  String number = "5"
  number.equals(i + j);
</pre>
<p>Since, it is difficult to determine what kind of Object is being concatenated all ident concatenation is considered unsafe.</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AS1132'>S1132</a> instead.
</p>Z
CODE_SMELL
¬
Rcheckstyle:com.puppycrawl.tools.checkstyle.checks.regexp.RegexpSinglelineJavaCheckÎ

checkstyleGcom.puppycrawl.tools.checkstyle.checks.regexp.RegexpSinglelineJavaCheckRegexp Singleline Java"MAJOR*java2'Checker/TreeWalker/RegexpSinglelineJava:∑<p>This class is variation on RegexpSingleline for detecting single lines that match a supplied regular expression in Java files. It supports suppressing matches in Java comments.</p>@Z
CODE_SMELL
¶
Hcheckstyle:com.puppycrawl.tools.checkstyle.checks.blocks.RightCurlyCheckŸ

checkstyle=com.puppycrawl.tools.checkstyle.checks.blocks.RightCurlyCheckRight Curly"MINOR*java2Checker/TreeWalker/RightCurly:ƒChecks the placement of right curly braces.

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3ARightCurlyBraceStartLineCheck'>RightCurlyBraceStartLineCheck</a> instead.
</p>@Z
CODE_SMELL
ò
Scheckstyle:com.puppycrawl.tools.checkstyle.checks.metrics.CyclomaticComplexityCheck¿

checkstyleHcom.puppycrawl.tools.checkstyle.checks.metrics.CyclomaticComplexityCheckCyclomatic Complexity"MAJOR*java2'Checker/TreeWalker/CyclomaticComplexity:é<p>
Checks cyclomatic complexity of methods against a specified limit. The complexity is measured by the number of if, while, do, for, ?:, catch, switch, case  statements, and operators && and || (plus one) in the body of a constructor, method, static initializer, or instance initializer. It is a measure of the minimum number of possible paths through the source and therefore the number of required tests. Generally 1-4 is considered good, 5-7 ok, 8-10 consider re-factoring, and 11+ re-factor now !
</p>

<p>
This rule is deprecated, use <a href='/coding_rules#rule_key=squid%3AMethodCyclomaticComplexity'>MethodCyclomaticComplexity</a> instead.
</p>Z
CODE_SMELL
•
squid:S1258ï
squidS1258@Classes and enums with private members should have a constructor"MAJOR*java:∞<p>Non-abstract <code>class</code>es and <code>enum</code>s with non-<code>static</code>, <code>private</code> members should explicitly initialize
those members, either in a constructor or with a default value.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class A { // Noncompliant
  private int field;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class A {
  private int field;

  A(int field) {
    this.field = field;
  }
}
</pre>ZBUG
Ä
squid:S00115Ô
squidS001155Constant names should comply with a naming convention"CRITICAL*java2S115:Ñ<p>Shared coding conventions allow teams to collaborate efficiently. This rule checks that all constant names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression <code>^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$</code>:</p>
<pre>
public class MyClass {
  public static final int first = 1;
}

public enum MyEnum {
  first;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {
  public static final int FIRST = 1;
}

public enum MyEnum {
  FIRST;
}
</pre>Z
CODE_SMELL
å	
squid:S2226¸
squidS22260Servlets should not have mutable instance fields"MAJOR*java:ß<p>By contract, a servlet container creates one instance of each servlet and then a dedicated thread is attached to each new incoming HTTP request to
process this request. So all threads are sharing the servlet instances and by extension instance fields. To prevent any misunderstanding and
unexpected behavior at runtime, all servlet fields should then be either <code>static</code> and/or <code>final</code>, or simply removed.</p>
<p>With Struts 1.X, the same constraint exists on <code>org.apache.struts.action.Action</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyServlet extends HttpServlet {
  private String userName;  //As this field is shared by all users, it's obvious that this piece of information should be managed differently
  ...
}
</pre>
<p>or </p>
<pre>
public class MyAction extends Action {
  private String userName;  //Same reason
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/EYBUC">CERT, MSC11-J.</a> - Do not let session information leak within a servlet </li>
</ul>ZBUG
±
squid:S00116†
squidS001162Field names should comply with a naming convention"MINOR*java2S116:ª<p>Sharing some naming conventions is a key point to make it possible for a team to efficiently collaborate. This rule allows to check that field
names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression <code>^[a-z][a-zA-Z0-9]*$</code>:</p>
<pre>
class MyClass {
   private int my_field;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {
   private int myField;
}
</pre>Z
CODE_SMELL
˝
squid:S1135Ì
squidS1135Track uses of "TODO" tags"INFO*java:©<p><code>TODO</code> tags are commonly used to mark places where some more code is required, but which the developer wants to implement later.</p>
<p>Sometimes the developer will not have the time or will simply forget to get back to that tag.</p>
<p>This rule is meant to track those tags and to ensure that they do not go unnoticed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
void doSomething() {
  // TODO
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/546.html">MITRE, CWE-546</a> - Suspicious Comment </li>
</ul>Z
CODE_SMELL
‹
squid:S1134Ã
squidS1134Track uses of "FIXME" tags"MAJOR*java:Ü<p><code>FIXME</code> tags are commonly used to mark places where a bug is suspected, but which the developer wants to deal with later.</p>
<p>Sometimes the developer will not have the time or will simply forget to get back to that tag.</p>
<p>This rule is meant to track those tags and to ensure that they do not go unnoticed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int divide(int numerator, int denominator) {
  return numerator / denominator;              // FIXME denominator value might be  0
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/546.html">MITRE, CWE-546</a> - Suspicious Comment </li>
</ul>Z
CODE_SMELL
æ
squid:S00114≠
squidS001146Interface names should comply with a naming convention"MINOR*java2S114:ƒ<p>Sharing some naming conventions is a key point to make it possible for a team to efficiently collaborate. This rule allows to check that all
interface names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression <code>^[A-Z][a-zA-Z0-9]*$</code>:</p>
<pre>
public interface myInterface {...} // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
public interface MyInterface {...}
</pre>Z
CODE_SMELL
œ
squid:S2221ø
squidS2221D"Exception" should not be caught when not required by called methods"MAJOR*java:÷
<p>Catching <code>Exception</code> seems like an efficient way to handle multiple possible exceptions. Unfortunately, it traps all exception types,
both checked and runtime exceptions, thereby casting too broad a net. Indeed, was it really the intention of developers to also catch runtime
exceptions? To prevent any misunderstanding, if both checked and runtime exceptions are really expected to be caught, they should be explicitly listed
in the <code>catch</code> clause.</p>
<p>This rule raises an issue if <code>Exception</code> is caught when it is not explicitly thrown by a method in the <code>try</code> block.</p>
<h2>Noncompliant Code Example</h2>
<pre>
try {
  // do something that might throw an UnsupportedDataTypeException or UnsupportedEncodingException
} catch (Exception e) { // Noncompliant
  // log exception ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
try {
  // do something
} catch (UnsupportedEncodingException|UnsupportedDataTypeException|RuntimeException e) {
  // log exception ...
}
</pre>
<p>or if runtime exceptions should not be caught:</p>
<pre>
try {
  // do something
} catch (UnsupportedEncodingException|UnsupportedDataTypeException e) {
  // log exception ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/396.html">MITRE, CWE-396</a> - Declaration of Catch for Generic Exception </li>
</ul>ZBUG
·
squid:S1133—
squidS1133!Deprecated code should be removed"INFO*java:Ö<p>This rule is meant to be used as a way to track code which is marked as being deprecated. Deprecated code should eventually be removed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class Foo {
  /**
   * @deprecated
   */
  public void foo() {    // Noncompliant
  }

  @Deprecated            // Noncompliant
  public void bar() {
  }

  public void baz() {    // Compliant
  }
}
</pre>Z
CODE_SMELL
ø
squid:S00119Æ
squidS00119;Type parameter names should comply with a naming convention"MINOR*java2S119:¿<p>Shared naming conventions make it possible for a team to collaborate efficiently. Following the established convention of single-letter type
parameter names helps users and maintainers of your code quickly see the difference between a type parameter and a poorly named class.</p>
<p>This rule check that all type parameter names match a provided regular expression. The following code snippets use the default regular
expression.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass&lt;TYPE&gt; { // Noncompliant
  &lt;TYPE&gt; void method(TYPE t) { // Noncompliant
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass&lt;T&gt; {
  &lt;T&gt; void method(T t) {
  }
}
</pre>Z
CODE_SMELL
∫	
squid:S3553™	
squidS3553,"Optional" should not be used for parameters"MAJOR*java:“<p>The Java language authors have been quite frank that <code>Optional</code> was intended for use only as a return type, as a way to convey that a
method may or may not return a value. </p>
<p>And for that, it's valuable but using <code>Optional</code> on the input side increases the work you have to do in the method without really
increasing the value. With an <code>Optional</code> parameter, you go from having 2 possible inputs: null and not-null, to three: null,
non-null-without-value, and non-null-with-value. Add to that the fact that overloading has long been available to convey that some parameters are
optional, and there's really no reason to have <code>Optional</code> parameters.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public String sayHello(Optional&lt;String&gt; name) {  // Noncompliant
  if (name == null || !name.isPresent()) {
    return "Hello World";
  } else {
    return "Hello " + name;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public String sayHello(String name) {
  if (name == null) {
    return "Hello World";
  } else {
    return "Hello " + name;
  }
}
</pre>Z
CODE_SMELL
ö
squid:S2222ä
squidS2222Locks should be released"CRITICAL*java: <p>If a lock is acquired and released within a method, then it must be released along all execution paths of that method.</p>
<p>Failing to do so will expose the conditional locking logic to the method's callers and hence be deadlock-prone.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {
  private Lock lock = new Lock();

  public void doSomething() {
    lock.lock(); // Noncompliant
    if (isInitialized()) {
      // ...
      lock.unlock();
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {
  private Lock lock = new Lock();

  public void doSomething() {
    if (isInitialized()) {
      lock.lock();
      // ...
      lock.unlock();
    }
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://cwe.mitre.org/data/definitions/459.html">MITRE, CWE-459</a> - Incomplete Cleanup </li>
</ul>ZBUG
‰
squid:S1132‘
squidS1132MStrings literals should be placed on the left side when checking for equality"MINOR*java:‚<p>It is preferable to place string literals on the left-hand side of an <code>equals()</code> or <code>equalsIgnoreCase()</code> method call.</p>
<p>This prevents null pointer exceptions from being raised, as a string literal can never be null by definition.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String myString = null;

System.out.println("Equal? " + myString.equals("foo"));                        // Noncompliant; will raise a NPE
System.out.println("Equal? " + (myString != null &amp;&amp; myString.equals("foo")));  // Noncompliant; null check could be removed
</pre>
<h2>Compliant Solution</h2>
<pre>
System.out.println("Equal?" + "foo".equals(myString));                         // properly deals with the null case
</pre>ZBUG
•
squid:S00117î
squidS00117PLocal variable and method parameter names should comply with a naming convention"MINOR*java2S117:ë<p>Sharing some naming conventions is a key point to make it possible for a team to efficiently collaborate. This rule allows to check that all local
variable and function parameter names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression <code>^[a-z][a-zA-Z0-9]*$</code>:</p>
<pre>
public void doSomething(int my_param) {
  int LOCAL;
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(int myParam) {
  int local;
  ...
}
</pre>
<h2>Exceptions</h2>
<p>Loop counters are ignored by this rule.</p>
<pre>
for (int i = 0; i &lt; limit; i++) {  // Compliant
  // ...
}
</pre>Z
CODE_SMELL
ß
squid:S2583ó
squidS2583FConditions should not unconditionally evaluate to "TRUE" or to "FALSE""MAJOR*java:¨<p>Conditional statements using a condition which cannot be anything but <code>FALSE</code> have the effect of making blocks of code non-functional.
If the condition cannot evaluate to anything but <code>TRUE</code>, the conditional statement is completely redundant, and makes the code less
readable.</p>
<p>It is quite likely that the code does not match the programmer's intent.</p>
<p>Either the condition should be removed or it should be updated so that it does not always evaluate to <code>TRUE</code> or <code>FALSE</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
//foo can't be both equal and not equal to bar in the same expression
if( foo == bar &amp;&amp; something &amp;&amp; foo != bar) {...}
</pre>
<pre>
private void compute(int foo) {
  int four = 4;
  if (foo == four ) {
    doSomething();
    // We know foo is equal to the four variable at this point, so the next condition is always false
    if (foo &gt; four) {...}
    ...
  }
  ...
}
</pre>
<pre>
private void compute(boolean foo) {
  if (foo) {
    return;
  }
  doSomething();
  // foo is always false here
  if (foo){...}
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 13.7 - Boolean operations whose results are invariant shall not be permitted. </li>
  <li> MISRA C:2012, 14.3 - Controlling expressions shall not be invariant </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/489">MITRE, CWE-489</a> - Leftover Debug Code </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/570">MITRE, CWE-570</a> - Expression is Always False </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/571">MITRE, CWE-571</a> - Expression is Always True </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>ZBUG
ã
squid:S00118˙
squidS00118;Abstract class names should comply with a naming convention"MINOR*java2S118:å<p>Sharing some naming conventions is a key point to make it possible for a team to efficiently collaborate. This rule allows to check that all
abstract class names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression: <code>^Abstract[A-Z][a-zA-Z0-9]*$</code>:</p>
<pre>
abstract class MyClass { // Noncompliant
}

class AbstractLikeClass { // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
abstract class MyAbstractClass {
}

class LikeClass {
}
</pre>Z
CODE_SMELL
Ä
squid:S3318
squidS3318/Untrusted data should not be stored in sessions"MAJOR*java:í<p>Data in a web session is considered inside the "trust boundary". That is, it is assumed to be trustworthy. But storing unvetted data from an
unauthenticated user violates the trust boundary, and may lead to that data being used inappropriately.</p>
<p>This rule raises an issue when data from <code>Cookie</code>s or <code>HttpServletRequest</code>s is stored in a session. </p>
<h2>Noncompliant Code Example</h2>
<pre>
login = request.getParameter("login");
session.setAttribute("login", login);  // Noncompliant
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/501">MITRE, CWE-501</a> - Trust Boundary Violation </li>
</ul>ZVULNERABILITY
ü

squid:S2109è

squidS2109>Reflection should not be used to check non-runtime annotations"MAJOR*java:¨	<p>The writer of an annotation can set one of three retention policies for it:</p>
<ul>
  <li> <code>RetentionPolicy.SOURCE</code> - these annotations are dropped during compilation, E.G. <code>@Override</code>,
  <code>@SuppressWarnings</code>. </li>
  <li> <code>RetentionPolicy.CLASS</code> - these annotations are present in a compiled class but not loaded into the JVM at runtime. This is the
  default. </li>
  <li> <code>RetentionPolicy.RUNTIME</code> - these annotations are present in the class file and loaded into the JVM. </li>
</ul>
<p>Only annotations that have been given a <code>RUNTIME</code> retention policy will be available to reflection. Testing for annotations with any
other retention policy is simply an error, since the test will always return false.</p>
<p>This rule checks that reflection is not used to detect annotations that do not have <code>RUNTIME</code> retention.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Method m = String.class.getMethod("getBytes", new Class[] {int.class,
int.class, byte[].class, int.class});
if (m.isAnnotationPresent(Override.class)) {  // Noncompliant; test will always return false, even when @Override is present in the code
</pre>ZBUG
Ω
squid:S3437≠
squidS3437,Value-based objects should not be serialized"MINOR*java:‹<p>According to the documentation,</p>
<blockquote>
  A program may produce unpredictable results if it attempts to distinguish two references to equal values of a value-based class, whether directly
  via reference equality or indirectly via an appeal to synchronization, identity hashing, serialization...
</blockquote>
<p>For example (credit to Brian Goetz), imagine Foo is a value-based class:</p>
<pre>
Foo[] arr = new Foo[2];
arr[0] = new Foo(0);
arr[1] = new Foo(0);
</pre>
<p>Serialization promises that on deserialization of arr, elements 0 and 1 will not be aliased. Similarly, in:</p>
<pre>
Foo[] arr = new Foo[2];
arr[0] = new Foo(0);
arr[1] = arr[0];
</pre>
<p>Serialization promises that on deserialization of <code>arr</code>, elements 0 and 1 <strong>will</strong> be aliased.</p>
<p>While these promises are coincidentally fulfilled in current implementations of Java, that is not guaranteed in the future, particularly when true
value types are introduced in the language.</p>
<p>This rule raises an issue when a <code>Serializable</code> class defines a non-transient, non-static field field whose type is a known serializable
value-based class. Known serializable value-based classes are: all the classes in the <code>java.time</code> package except <code>Clock</code>; the
date classes for alternate calendars: <code>HijrahDate</code>, <code>JapaneseDate</code>, <code>MinguaDate</code>, <code>ThaiBuddhistDate</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass implements Serializable {
  private HijrahDate date;  // Noncompliant; mark this transient
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass implements Serializable {
  private transient HijrahDate date;
  // ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://docs.oracle.com/javase/8/docs/api/java/lang/doc-files/ValueBased.html">Value-based classes</a> </li>
</ul>ZBUG
â
squid:S3438˘
squidS3438K"SingleConnectionFactory" instances should be set to "reconnectOnException""MAJOR*java:â<p>Use of a Spring <code>SingleConnectionFactory</code> without enabling the <code>reconnectOnException</code> setting will prevent automatic
connection recovery when the connection goes bad. </p>
<p>That's because the <code>reconnectOnException</code> property defaults to <code>false</code>. As a result, even if the code that uses this
connection factory (Spring's <code>DefaultMessageListenerContainer</code> or your own code) has reconnect logic, that code won't work because the
<code>SingleConnectionFactory</code> will act like a single-connection pool by preventing connection <code>close</code> calls from actually closing
anything. As a result, subsequent factory <code>create</code> operations will just hand back the original broken <code>Connection</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
 &lt;bean id="singleCF" class="org.springframework.jms.connection.SingleConnectionFactory"&gt;  &lt;!-- Noncompliant --&gt;
   &lt;constructor-arg ref="dummyConnectionFactory" /&gt;
 &lt;/bean&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
 &lt;bean id="singleCF" class="org.springframework.jms.connection.SingleConnectionFactory" p:reconnectOnException="true"&gt;
   &lt;constructor-arg ref="dummyConnectionFactory" /&gt;
 &lt;/bean&gt;
</pre>
<p>or</p>
<pre>
 &lt;bean id="singleCF" class="org.springframework.jms.connection.SingleConnectionFactory"&gt;
   &lt;constructor-arg ref="dummyConnectionFactory" /&gt;
   &lt;property name="reconnectOnException"&gt;&lt;value&gt;true&lt;/value&gt;&lt;/property&gt;
 &lt;/bean&gt;
</pre>ZBUG
˛

squid:S864Ô
squidS864OLimited dependence should be placed on operator precedence rules in expressions"MAJOR*java:ı<p>The rules of operator precedence are complicated and can lead to errors. For this reason, parentheses should be used for clarification in complex
statements. However, this does not mean that parentheses should be gratuitously added around every operation. </p>
<p>This rule raises issues when <code>&amp;&amp;</code> and <code>||</code> are used in combination, when assignment and equality or relational
operators are used in together in a condition, and for other operator combinations according to the following table:</p>
<table>
  <tbody>
    <tr>
      <td> </td>
      <td><code>+</code>, <code>-</code>, <code>*</code>, <code>/</code>, <code>%</code></td>
      <td><code>&lt;&lt;</code>, <code>&gt;&gt;</code>, <code>&gt;&gt;&gt;</code></td>
      <td><code>&amp;</code></td>
      <td><code>^</code></td>
      <td> <code>|</code> </td>
    </tr>
    <tr>
      <td><code>+</code>, <code>-</code>, <code>*</code>, <code>/</code>, <code>%</code></td>
      <td> </td>
      <td>x</td>
      <td>x</td>
      <td>x</td>
      <td>x</td>
    </tr>
    <tr>
      <td><code>&lt;&lt;</code>, <code>&gt;&gt;</code>, <code>&gt;&gt;&gt;</code></td>
      <td>x</td>
      <td> </td>
      <td>x</td>
      <td>x</td>
      <td>x</td>
    </tr>
    <tr>
      <td><code>&amp;</code></td>
      <td>x</td>
      <td>x</td>
      <td> </td>
      <td>x</td>
      <td>x</td>
    </tr>
    <tr>
      <td><code>^</code></td>
      <td>x</td>
      <td>x</td>
      <td>x</td>
      <td> </td>
      <td>x</td>
    </tr>
    <tr>
      <td> <code>|</code> </td>
      <td>x</td>
      <td>x</td>
      <td>x</td>
      <td>x</td>
      <td> </td>
    </tr>
  </tbody>
</table>
<h2>Noncompliant Code Example</h2>
<pre>
x = a + b - c;
x = a + 1 &lt;&lt; b;  // Noncompliant

if ( a &gt; b || c &lt; d || a == d) {...}
if ( a &gt; b &amp;&amp; c &lt; d || a == b) {...}  // Noncompliant
if (a = f(b,c) == 1) { ... } // Noncompliant; == evaluated first
</pre>
<h2>Compliant Solution</h2>
<pre>
x = a + b - c;
x = (a + 1) &lt;&lt; b;

if ( a &gt; b || c &lt; d || a == d) {...}
if ( (a &gt; b &amp;&amp; c &lt; d) || a == b) {...}
if ( (a = f(b,c)) == 1) { ... }
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 12.1 - Limited dependence should be placed on C's operator precedence rules in expressions </li>
  <li> MISRA C:2004, 12.2 - The value of an expression shall be the same under any order of evaluation that the standard permits. </li>
  <li> MISRA C:2004, 12.5 - The operands of a logical &amp;&amp; or || shall be primary-expressions. </li>
  <li> MISRA C++:2008, 5-0-1 - The value of an expression shall be the same under any order of evaluation that the standard permits. </li>
  <li> MISRA C++:2008, 5-0-2 - Limited dependence should be placed on C++ operator precedence rules in expressions </li>
  <li> MISRA C++:2008, 5-2-1 - Each operand of a logical &amp;&amp; or || shall be a postfix-expression. </li>
  <li> MISRA C:2012, 12.1 - The precedence of operators within expressions should be made explicit </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/_wI">CERT, EXP00-C.</a> - Use parentheses for precedence of operation </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/VoAyAQ">CERT, EXP00-CPP.</a> - Use parentheses for precedence of operation </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9wHEAw">CERT, EXP53-J.</a> - Use parentheses for precedence of operation </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/783.html">MITRE, CWE-783</a> - Operator Precedence Logic Error </li>
</ul>Z
CODE_SMELL
ﬁ
squid:S00122Õ
squidS00122&Statements should be on separate lines"MAJOR*java2S122:Ù<p>For better readability, do not put more than one statement on a single line.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if(someCondition) doSomething();
</pre>
<h2>Compliant Solution</h2>
<pre>
if(someCondition) {
  doSomething();
}
</pre>Z
CODE_SMELL
ı
squid:S00120‰
squidS001204Package names should comply with a naming convention"MINOR*java2S120:˝<p>Shared coding conventions allow teams to collaborate efficiently. This rule checks that all package names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression <code>^[a-z]+(\.[a-z][a-z0-9]*)*$</code>:</p>
<pre>
package org.exAmple; // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
package org.example;
</pre>Z
CODE_SMELL
ƒ
squid:S00121≥
squidS00121*Control structures should use curly braces"CRITICAL*java2S121:”<p>While not technically incorrect, the omission of curly braces can be misleading, and may lead to the introduction of errors during maintenance.</p>
<h2>Noncompliant Code Example</h2>
<pre>
// the two statements seems to be attached to the if statement, but that is only true for the first one:
if (condition)
  executeSomething();
  checkSomething();
</pre>
<h2>Compliant Solution</h2>
<pre>
if (condition) {
  executeSomething();
  checkSomething();
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 14.8 - The statement forming the body of a switch, while, do ... while or for statement shall be a compound statement </li>
  <li> MISRA C:2004, 14.9 - An if (expression) construct shall be followed by a compound statement. The else keyword shall be followed by either a
  compound statement, or another if statement </li>
  <li> MISRA C++:2008, 6-3-1 - The statement forming the body of a switch, while, do ... while or for statement shall be a compound statement </li>
  <li> MISRA C++:2008, 6-4-1 - An if (condition) construct shall be followed by a compound statement. The else keyword shall be followed by either a
  compound statement, or another if statement </li>
  <li> MISRA C:2012, 15.6 - The body of an iteration-statement or a selection-statement shall be a compound-statement </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/1QGMAg">CERT, EXP19-C.</a> - Use braces for the body of an if, for, or while statement
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/3wHEAw">CERT, EXP52-J.</a> - Use braces for the body of an if, for, or while statement
  </li>
</ul>Z
CODE_SMELL
ö
squid:S2236ä
squidS2236ZMethods "wait(...)", "notify()" and "notifyAll()" should not be called on Thread instances"BLOCKER*java:â<p>The methods <code>wait(...)</code>, <code>notify()</code> and <code>notifyAll()</code> are available on a <code>Thread</code> instance, but only
because all classes in Java extend <code>Object</code> and therefore automatically inherit those methods. But there are two very good reasons for not
calling them on a <code>Thread</code>:</p>
<ul>
  <li> Internally, the JVM relies on these methods to change the state of the Thread (<code>BLOCKED</code>, <code>WAITING</code>, ...), so calling
  them will corrupt the behavior of the JVM. </li>
  <li> It is not clear (perhaps even to the original coder) what is really expected. For instance, it is waiting for the execution of the Thread to
  suspended, or is it the acquisition of the object monitor that is waited for? </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
Thread myThread = new Thread(new RunnableJob());
...
myThread.wait(2000);
</pre>ZBUG
Î
squid:S1148€
squidS11483Throwable.printStackTrace(...) should not be called"MINOR*java:˘<p><code>Throwable.printStackTrace(...)</code> prints a <code>Throwable</code> and its stack trace to some stream. By default that stream
<code>System.Err</code>, which could inadvertently expose sensitive information.</p>
<p>Loggers should be used instead to print <code>Throwable</code>s, as they have many advantages:</p>
<ul>
  <li> Users are able to easily retrieve the logs. </li>
  <li> The format of log messages is uniform and allow users to browse the logs easily. </li>
</ul>
<p>This rule raises an issue when <code>printStackTrace</code> is used without arguments, i.e. when the stack trace is printed to the default
stream.</p>
<h2>Noncompliant Code Example</h2>
<pre>
try {
  /* ... */
} catch(Exception e) {
  e.printStackTrace();        // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
try {
  /* ... */
} catch(Exception e) {
  LOGGER.log("context", e);
}
</pre>ZVULNERABILITY
È
squid:S00104ÿ
squidS00104,Files should not have too many lines of code"MAJOR*java2S104:˘<p>A source file that grows too much tends to aggregate too many responsibilities and inevitably becomes harder to understand and therefore to
maintain. Above a specific threshold, it is strongly advised to refactor it into smaller pieces of code which focus on well defined tasks. Those
smaller files will not only be easier to understand but also probably easier to test.</p>Z
CODE_SMELL
·
squid:S2116—
squidS2116A"hashCode" and "toString" should not be called on array instances"MAJOR*java:Î<p>While <code>hashCode</code> and <code>toString</code> are available on arrays, they are largely useless. <code>hashCode</code> returns the array's
"identity hash code", and <code>toString</code> returns nearly the same value. Neither method's output actually reflects the array's contents.
Instead, you should pass the array to the relevant static <code>Arrays</code> method.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public static void main( String[] args )
{
    String argStr = args.toString(); // Noncompliant
    int argHash = args.hashCode(); // Noncompliant

</pre>
<h2>Compliant Solution</h2>
<pre>
public static void main( String[] args )
{
    String argStr = Arrays.toString(args);
    int argHash = Arrays.hashCode(args);

</pre>ZBUG
¬
squid:S1147≤
squidS1147!Exit methods should not be called"BLOCKER*java:Í<p>Calling <code>System.exit(int status)</code> or <code>Rutime.getRuntime().exit(int status)</code> calls the shutdown hooks and shuts downs the
entire Java virtual machine. Calling <code>Runtime.getRuntime().halt(int)</code> does an immediate shutdown, without calling the shutdown hooks, and
skipping finalization.</p>
<p>Each of these methods should be used with extreme care, and only when the intent is to stop the whole Java process. For instance, none of them
should be called from applications running in a J2EE container.</p>
<h2>Noncompliant Code Example</h2>
<pre>
System.exit(0);
Runtime.getRuntime().exit(0);
Runtime.getRuntime().halt(0);
</pre>
<h2>Exceptions</h2>
<p>These methods are ignored inside <code>main</code>.</p>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/382.html">MITRE, CWE-382</a> - Use of System.exit() </li>
</ul>ZBUG
”
squid:S2235√
squidS22351IllegalMonitorStateException should not be caught"CRITICAL*java:„<p>According to Oracle Javadoc:</p>
<blockquote>
  <p><code>IllegalMonitorStateException</code> is thrown when a thread has attempted to wait on an object's monitor or to notify other threads waiting
  on an object's monitor without owning the specified monitor.</p>
</blockquote>
<p>In other words, this exception can be thrown only in case of bad design because <code>Object.wait(...)</code>, <code>Object.notify()</code> and
<code>Object.notifyAll()</code> methods should never be called on an object whose monitor is not held. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething(){
  ...
  try {
    ...
    anObject.notify();
    ...
  } catch(IllegalMonitorStateException e) {
    ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(){
  ...
  synchronized(anObject) {
    ...
    anObject.notify();
    ...
  }
}
</pre>Z
CODE_SMELL
Ï
squid:S2114‹
squidS2114BCollections should not be passed as arguments to their own methods"MAJOR*java:ı<p>Passing a collection as an argument to the collection's own method is either an error - some other argument was intended - or simply nonsensical
code. </p>
<p>Further, because some methods require that the argument remain unmodified during the execution, passing a collection to itself can result in
undefined behavior. </p>
<h2>Noncompliant Code Example</h2>
<pre>
List &lt;Object&gt; objs = new ArrayList&lt;Object&gt;();
objs.add("Hello");

objs.add(objs); // Noncompliant; StackOverflowException if objs.hashCode() called
objs.addAll(objs); // Noncompliant; behavior undefined
objs.containsAll(objs); // Noncompliant; always true
objs.removeAll(objs); // Noncompliant; confusing. Use clear() instead
objs.retainAll(objs); // Noncompliant; NOOP
</pre>ZBUG
⁄
squid:S1145 
squidS1145FUseless "if(true) {...}" and "if(false){...}" blocks should be removed"MAJOR*java:ﬂ<p><code>if</code> statements with conditions that are always false have the effect of making blocks of code non-functional. <code>if</code>
statements with conditions that are always true are completely redundant, and make the code less readable.</p>
<p>There are three possible causes for the presence of such code: </p>
<ul>
  <li> An if statement was changed during debugging and that debug code has been committed. </li>
  <li> Some value was left unset. </li>
  <li> Some logic is not doing what the programmer thought it did. </li>
</ul>
<p>In any of these cases, unconditional <code>if</code> statements should be removed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (true) {
  doSomething();
}
...
if (false) {
  doSomethingElse();
}

if (2 &lt; 3 ) { ... }  // Noncompliant; always false

int i = 0;
int j = 0;
// ...
j = foo();

if (j &gt; 0 &amp;&amp; i &gt; 0) { ... }  // Noncompliant; always false - i never set after initialization

boolean b = true;
//...
if (b || !b) { ... }  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
doSomething();
...
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/489.html">MITRE, CWE-489</a> - Leftover Debug Code </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/570.html">MITRE, CWE-570</a> - Expression is Always False </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/571.html">MITRE, CWE-571</a> - Expression is Always True </li>
  <li> MISRA C:2004, 13.7 - Boolean operations whose results are invariant shall not be permitted. </li>
  <li> MISRA C:2012, 14.3 - Controlling expressions shall not be invariant </li>
</ul>
<h2>Deprecated</h2>
<p>This rule is deprecated; use <a href='/coding_rules#rule_key=squid%3AS2583'>S2583</a> instead.</p>ZBUG
”
squid:S00103¬
squidS00103Lines should not be too long"MAJOR*java2S103:t<p>Having to scroll horizontally makes it harder to get a quick overview and understanding of any piece of code.</p>Z
CODE_SMELL
⁄
squid:S2111 
squidS2111'"BigDecimal(double)" should not be used"MAJOR*java:˛<p>Because of floating point imprecision, you're unlikely to get the value you expect from the <code>BigDecimal(double)</code> constructor. </p>
<p>From <a href="http://docs.oracle.com/javase/7/docs/api/java/math/BigDecimal.html#BigDecimal(double)">the JavaDocs</a>:</p>
<blockquote>
  The results of this constructor can be somewhat unpredictable. One might assume that writing new BigDecimal(0.1) in Java creates a BigDecimal which
  is exactly equal to 0.1 (an unscaled value of 1, with a scale of 1), but it is actually equal to
  0.1000000000000000055511151231257827021181583404541015625. This is because 0.1 cannot be represented exactly as a double (or, for that matter, as a
  binary fraction of any finite length). Thus, the value that is being passed in to the constructor is not exactly equal to 0.1, appearances
  notwithstanding.
</blockquote>
<p>Instead, you should use <code>BigDecimal.valueOf</code>, which uses a string under the covers to eliminate floating point rounding errors.</p>
<h2>Noncompliant Code Example</h2>
<pre>
double d = 1.1;

BigDecimal bd1 = new BigDecimal(d); // Noncompliant; see comment above
BigDecimal bd2 = new BigDecimal(1.1); // Noncompliant; same result
</pre>
<h2>Compliant Solution</h2>
<pre>
double d = 1.1;

BigDecimal bd1 = BigDecimal.valueOf(d);
BigDecimal bd2 = BigDecimal.valueOf(1.1);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NQAVAg">CERT, NUM10-J.</a> - Do not construct BigDecimal objects from floating-point
  literals </li>
</ul>ZBUG
È
squid:S2232Ÿ
squidS2232'"ResultSet.isLast()" should not be used"MAJOR*java:ç<p>There are several reasons to avoid <code>ResultSet.isLast()</code>. First, support for this method is optional for <code>TYPE_FORWARD_ONLY</code>
result sets. Second, it can be expensive (the driver may need to fetch the next row to answer the question). Finally, the specification is not clear
on what should be returned when the <code>ResultSet</code> is empty, so some drivers may return the opposite of what is expected.</p>
<h2>Noncompliant Code Example</h2>
<pre>
stmt.executeQuery("SELECT name, address FROM PERSON");
ResultSet rs = stmt.getResultSet();
while (! rs.isLast()) { // Noncompliant
  // process row
}
</pre>
<h2>Compliant Solution</h2>
<pre>
ResultSet rs = stmt.executeQuery("SELECT name, address FROM PERSON");
while (! rs.next()) {
  // process row
}
</pre>ZBUG
í
squid:S00108Å
squidS00108.Nested blocks of code should not be left empty"MAJOR*java2S108:†<p>Most of the time a block of code is empty when a piece of code is really missing. So such empty block must be either filled or removed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
for (int i = 0; i &lt; 42; i++){}  // Empty on purpose or missing piece of code ?
</pre>
<h2>Exceptions</h2>
<p>When a block contains a comment, this block is not considered to be empty unless it is a <code>synchronized</code> block. <code>synchronized</code>
blocks are still considered empty even with comments because they can still affect program flow.</p>Z
CODE_SMELL
’
squid:S1264≈
squidS12645A "while" loop should be used instead of a "for" loop"MINOR*java:‰<p>When only the condition expression is defined in a <code>for</code> loop, but the init and increment expressions are missing, a <code>while</code>
loop should be used instead to increase readability. </p>
<h2>Noncompliant Code Example</h2>
<pre>
for (;condition;) { /*...*/ }
</pre>
<h2>Compliant Solution</h2>
<pre>
while (condition) { /*...*/ }
</pre>Z
CODE_SMELL
á	
squid:S2112˜
squidS21121"URL.hashCode" and "URL.equals" should be avoided"MAJOR*java:°<p>The <code>equals</code> and <code>hashCode</code> methods of <code>java.net.URL</code> both make calls out to the Internet and are blocking
operations. <code>URI</code> on the other hand makes no such calls and should be used instead unless the specific <code>URL</code> functionality is
required.</p>
<p>This rule checks for uses of <code>URL</code> 's in <code>Map</code> and <code>Set</code> , and for explicit calls to the <code>equals</code> and
<code>hashCode</code> methods.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void checkUrl(URL url) {
  Set&lt;URL&gt; sites = new HashSet&lt;URL&gt;();  // Noncompliant

  URL homepage = new URL("http://sonarsource.com");  // Compliant
  if (homepage.equals(url)) { // Noncompliant
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void checkUrl(URL url) {
  Set&lt;URI&gt; sites = new HashSet&lt;URI&gt;();  // Compliant

  URI homepage = new URI("http://sonarsource.com");  // Compliant
  URI uri = url.toURI();
  if (homepage.equals(uri)) {  // Compliant
    // ...
  }
}
</pre>ZBUG
Ê
squid:S1143÷
squidS11434Jump statements should not occur in "finally" blocks"MAJOR*java:˝<p>Using <code>return</code>, <code>break</code>, <code>throw</code>, and so on from a <code>finally</code> block suppresses the propagation of any
unhandled <code>Throwable</code> which was thrown in the <code>try</code> or <code>catch</code> block.</p>
<p>This rule raises an issue when a jump statement (<code>break</code>, <code>continue</code>, <code>return</code>, <code>throw</code>, and
<code>goto</code>) would force control flow to leave a <code>finally</code> block. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public static void main(String[] args) {
  try {
    doSomethingWhichThrowsException();
    System.out.println("OK");   // incorrect "OK" message is printed
  } catch (RuntimeException e) {
    System.out.println("ERROR");  // this message is not shown
  }
}

public static void doSomethingWhichThrowsException() {
  try {
    throw new RuntimeException();
  } finally {
    for (int i = 0; i &lt; 10; i ++) {
      //...
      if (q == i) {
        break; // ignored
      }
    }

    /* ... */
    return;      // Noncompliant - prevents the RuntimeException from being propagated
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public static void main(String[] args) {
  try {
    doSomethingWhichThrowsException();
    System.out.println("OK");
  } catch (RuntimeException e) {
    System.out.println("ERROR");  // "ERROR" is printed as expected
  }
}

public static void doSomethingWhichThrowsException() {
  try {
    throw new RuntimeException();
  } finally {
    for (int i = 0; i &lt; 10; i ++) {
      //...
      if (q == i) {
        break; // ignored
      }
    }

    /* ... */
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/584.html">MITRE, CWE-584</a> - Return Inside Finally Block </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/mIEbAQ">CERT, ERR04-J.</a> - Do not complete abruptly from a finally block </li>
</ul>ZBUG
‚
squid:S2230“
squidS22301Non-public methods should not be "@Transactional""MAJOR*java:¸<p>Marking a non-public method <code>@Transactional</code> is both useless and misleading because Spring doesn't "see" non-<code>public</code>
methods, and so makes no provision for their proper invocation. Nor does Spring make provision for the methods invoked by the method it called.</p>
<p>Therefore marking a <code>private</code> method, for instance, <code>@Transactional</code> can only result in a runtime error or exception if the
method is actually written to be <code>@Transactional</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@Transactional  // Noncompliant
private void doTheThing(ArgClass arg) {
  // ...
}
</pre>ZBUG
°
squid:S1142ë
squidS11422Methods should not have too many return statements"MAJOR*java:≥<p>Having too many return statements in a method increases the method's essential complexity because the flow of execution is broken each time a
return statement is encountered. This makes it harder to read and understand the logic of the method.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold of 3:</p>
<pre>
public boolean myMethod() { // Noncompliant; there are 4 return statements
  if (condition1) {
    return true;
  } else {
    if (condition2) {
      return false;
    } else {
      return true;
    }
  }
  return false;
}
</pre>Z
CODE_SMELL
º
squid:S2110¨
squidS2110(Invalid "Date" values should not be used"MAJOR*java:ﬂ<p>Whether the valid value ranges for <code>Date</code> fields start with 0 or 1 varies by field. For instance, month starts at 0, and day of month
starts at 1. Enter a date value that goes past the end of the valid range, and the date will roll without error or exception. For instance, enter 12
for month, and you'll get January of the following year.</p>
<p>This rule checks for bad values used in conjunction with <code>java.util.Date</code>, <code>java.sql.Date</code>, and
<code>java.util.Calendar</code>. Specifically, values outside of the valid ranges:</p>
<table>
  <tbody>
    <tr>
      <th>Field</th>
      <th>Valid</th>
    </tr>
    <tr>
      <td>month</td>
      <td>0-11</td>
    </tr>
    <tr>
      <td>date (day)</td>
      <td>0-31</td>
    </tr>
    <tr>
      <td>hour</td>
      <td>0-23</td>
    </tr>
    <tr>
      <td>minute</td>
      <td>0-60</td>
    </tr>
    <tr>
      <td>second</td>
      <td>0-61</td>
    </tr>
  </tbody>
</table>
<p>Note that this rule does not check for invalid leap years, leap seconds (second = 61), or invalid uses of the 31st day of the month.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Date d = new Date();
d.setDate(25);
d.setYear(2014);
d.setMonth(12);  // Noncompliant; rolls d into the next year

Calendar c = new GregorianCalendar(2014, 12, 25);  // Noncompliant
if (c.get(Calendar.MONTH) == 12) {  // Noncompliant; invalid comparison
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
Date d = new Date();
d.setDate(25);
d.setYear(2014);
d.setMonth(11);

Calendar c = new Gregorian Calendar(2014, 11, 25);
if (c.get(Calendar.MONTH) == 11) {
  // ...
}
</pre>ZBUG
…

squid:S881∫
squidS881~Increment (++) and decrement (--) operators should not be used in a method call or mixed with other operators in an expression"MAJOR*java:ë<p>The use of increment and decrement operators in method calls or in combination with other arithmetic operators is not recommended, because:</p>
<ul>
  <li> It can significantly impair the readability of the code. </li>
  <li> It introduces additional side effects into a statement, with the potential for undefined behavior. </li>
  <li> It is safer to use these operators in isolation from any other arithmetic operators. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
u8a = ++u8b + u8c--;
foo = bar++ / 4;
</pre>
<h2>Compliant Solution</h2>
<p>The following sequence is clearer and therefore safer:</p>
<pre>
++u8b;
u8a = u8b + u8c;
u8c--;
foo = bar / 4;
bar++;
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 12.1 - Limited dependence should be placed on the C operator precedence rules in expressions. </li>
  <li> MISRA C:2004, 12.13 - The increment (++) and decrement (--) operators should not be mixed with other operators in an expression. </li>
  <li> MISRA C++:2008, 5-2-10 - The increment (++) and decrement (--) operator should not be mixed with other operators in an expression. </li>
  <li> MISRA C:2012, 12.1 - The precedence of operators within expressions should be made explicit </li>
  <li> MISRA C:2012, 13.3 - A full expression containing an increment (++) or decrement (--) operator should have no other potential side effects
  other than that cause by the increment or decrement operator </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/ZwE">CERT, EXP30-C.</a> - Do not depend on the order of evaluation for side effects
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/fYAyAQ">CERT, EXP50-CPP.</a> - Do not depend on the order of evaluation for side
  effects </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/yQC7AQ">CERT, EXP05-J.</a> - Do not follow a write by a subsequent write or read of the
  same object within an expression </li>
</ul>Z
CODE_SMELL
¢
squid:S1141í
squidS1141%Try-catch blocks should not be nested"MAJOR*java:¡<p>Nesting <code>try</code>/<code>catch</code> blocks severely impacts the readability of source code because it makes it too difficult to understand
which block will catch which exception.</p>Z
CODE_SMELL
Ä
squid:S00107Ô
squidS00107+Methods should not have too many parameters"MAJOR*java2S107:ë<p>A long parameter list can indicate that a new structure should be created to wrap the numerous parameters or that the function is doing too many
things.</p>
<h2>Noncompliant Code Example</h2>
<p>With a maximum number of 4 parameters:</p>
<pre>
public void doSomething(int param1, int param2, int param3, String param4, long param5) {
...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(int param1, int param2, int param3, String param4) {
...
}
</pre>
<h2>Exceptions</h2>
<p>Methods annotated with Spring's <code>@RequestMapping</code> may have a lot of parameters, encapsulation being possible. Such methods are therefore
ignored.</p>Z
CODE_SMELL
∂	
squid:S2118¶	
squidS2118.Non-serializable classes should not be written"MAJOR*java:”<p>Nothing in a non-serializable class will be written out to file, and attempting to serialize such a class will result in an exception being thrown.
Only a class that <code>implements Serializable</code> or one that extends such a class can successfully be serialized (or de-serialized). </p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Vegetable {  // neither implements Serializable nor extends a class that does
  //...
}

public class Menu {
  public void meal() throws IOException {
    Vegetable veg;
    //...
    FileOutputStream fout = new FileOutputStream(veg.getName());
    ObjectOutputStream oos = new ObjectOutputStream(fout);
    oos.writeObject(veg);  // Noncompliant. Nothing will be written
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Vegetable implements Serializable {  // can now be serialized
  //...
}

public class Menu {
  public void meal() throws IOException {
    Vegetable veg;
    //...
    FileOutputStream fout = new FileOutputStream(veg.getName());
    ObjectOutputStream oos = new ObjectOutputStream(fout);
    oos.writeObject(veg);
  }
}
</pre>ZBUG
‚
squid:S1149“
squidS1149QSynchronized classes Vector, Hashtable, Stack and StringBuffer should not be used"MAJOR*java:‹<p>Early classes of the Java API, such as <code>Vector</code>, <code>Hashtable</code> and <code>StringBuffer</code>, were synchronized to make them
thread-safe. Unfortunately, synchronization has a big negative impact on performance, even when using these collections from a single thread.</p>
<p>It is better to use their new unsynchronized replacements:</p>
<ul>
  <li> <code>ArrayList</code> or <code>LinkedList</code> instead of <code>Vector</code> </li>
  <li> <code>Deque</code> instead of <code>Stack</code> </li>
  <li> <code>HashMap</code> instead of <code>Hashtable</code> </li>
  <li> <code>StringBuilder</code> instead of <code>StringBuffer</code> </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
Vector cats = new Vector();
</pre>
<h2>Compliant Solution</h2>
<pre>
ArrayList cats = new ArrayList();
</pre>
<h2>Exceptions</h2>
<p>Use of those synchronized classes is ignored in the signatures of overriding methods.</p>
<pre>
@Override
public Vector getCats() {...}
</pre>ZBUG
˙
squid:S00112È
squidS00112)Generic exceptions should never be thrown"MAJOR*java2S112:î<p>Using such generic exceptions as <code>Error</code>, <code>RuntimeException</code>, <code>Throwable</code>, and <code>Exception</code> prevents
calling methods from handling true, system-generated exceptions differently than application-generated errors. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public void foo(String bar) throws Throwable {  // Noncompliant
  throw new RuntimeException("My Message");     // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void foo(String bar) {
  throw new MyOwnRuntimeException("My Message");
}
</pre>
<h2>Exceptions</h2>
<p>Generic exceptions in the signatures of overriding methods are ignored.</p>
<pre>
@Override
public void myMethod() throws Exception {...}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/397.html">MITRE, CWE-397</a> - Declaration of Throws for Generic Exception </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/BoB3AQ">CERT, ERR07-J.</a> - Do not throw RuntimeException, Exception, or Throwable
  </li>
</ul>ZBUG
™

squid:S3655ö

squidS3655@Optional value should only be accessed after calling isPresent()"MAJOR*java:µ	<p><code>Optional</code> value can hold either a value or not. The value held in the <code>Optional</code> can be accessed using the
<code>get()</code> method, but it will throw a </p>
<p><code>NoSuchElementException</code> if there is no value present. To avoid the exception, calling the <code>isPresent()</code> method should always
be done before any call to <code>get()</code>.</p>
<p>Alternatively, note that other methods such as <code>orElse(...)</code>, <code>orElseGet(...)</code> or <code>orElseThrow(...)</code> can be used
to specify what to do with an empty <code>Optional</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Optional&lt;String&gt; value = this.getOptionalValue();

// ...

String stringValue = value.get(); // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
Optional&lt;String&gt; value = this.getOptionalValue();

// ...

if (value.isPresent()) {
  String stringValue = value.get();
}
</pre>
<p>or</p>
<pre>
Optional&lt;String&gt; value = this.getOptionalValue();

// ...

String stringValue = value.orElse("default");
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://cwe.mitre.org/data/definitions/476.html">MITRE, CWE-476</a> - NULL Pointer Dereference </li>
</ul>ZBUG
§
squid:S3776î
squidS37766Cognitive Complexity of methods should not be too high"CRITICAL*java:Ø<p>Cognitive Complexity is a measure of how hard the control flow of a method is to understand. Methods with high Cognitive Complexity will be
difficult to maintain.</p>
<h2>See</h2>
<ul>
  <li> <a href="http://redirect.sonarsource.com/doc/cognitive-complexity.html">Cognitive Complexity</a> </li>
</ul>Z
CODE_SMELL
Ç

squid:S2325Ú	
squidS2325D"private" methods that don't access instance data should be "static""MINOR*java:Ç	<p><code>private</code> methods that don't access instance data can be <code>static</code> to prevent any misunderstanding about the contract of the
method.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class Utilities {
  private static String magicWord = "magic";

  private String getMagicWord() { // Noncompliant
    return magicWord;
  }

  private void setMagicWord(String value) { // Noncompliant
    magicWord = value;
  }

}
</pre>
<h2>Compliant Solution</h2>
<pre>
class Utilities {
  private static String magicWord = "magic";

  private static String getMagicWord() {
    return magicWord;
  }

  private static void setMagicWord(String value) {
    magicWord = value;
  }

}
</pre>
<h2>Exceptions</h2>
<p>When <code>java.io.Serializable</code> is implemented the following three methods are excluded by the rule:</p>
<ul>
  <li> <code>private void writeObject(java.io.ObjectOutputStream out) throws IOException;</code> </li>
  <li> <code>private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException;</code> </li>
  <li> <code>private void readObjectNoData() throws ObjectStreamException;</code> </li>
</ul>Z
CODE_SMELL
é
squid:S2446˛
squidS2446"notifyAll" should be used"MAJOR*java:ø<p><code>notify</code> and <code>notifyAll</code> both wake up sleeping threads, but <code>notify</code> only rouses one, while <code>notifyAll</code>
rouses all of them. Since <code>notify</code> might not wake up the right thread, <code>notifyAll</code> should be used instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyThread extends Thread{

  @Override
  public void run(){
    synchronized(this){
      // ...
      notify();  // Noncompliant
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyThread extends Thread{

  @Override
  public void run(){
    synchronized(this){
      // ...
      notifyAll();
    }
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/OoAlAQ">CERT, THI02-J.</a> - Notify all waiting threads rather than a single thread
  </li>
</ul>ZBUG
·
squid:S2204—
squidS2204E".equals()" should not be used to test the values of "Atomic" classes"MAJOR*java:Á<p><code>AtomicInteger</code>, and <code>AtomicLong</code> extend <code>Number</code>, but they're distinct from <code>Integer</code> and
<code>Long</code> and should be handled differently. <code>AtomicInteger</code> and <code>AtomicLong</code> are designed to support lock-free,
thread-safe programming on single variables. As such, an <code>AtomicInteger</code> will only ever be "equal" to itself. Instead, you should
<code>.get()</code> the value and make comparisons on it.</p>
<p>This applies to all the atomic, seeming-primitive wrapper classes: <code>AtomicInteger</code>, <code>AtomicLong</code>, and
<code>AtomicBoolean</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
AtomicInteger aInt1 = new AtomicInteger(0);
AtomicInteger aInt2 = new AtomicInteger(0);

if (aInt1.equals(aInt2)) { ... }  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
AtomicInteger aInt1 = new AtomicInteger(0);
AtomicInteger aInt2 = new AtomicInteger(0);

if (aInt1.get() == aInt2.get()) { ... }
</pre>ZBUG
‡
squid:S1598–
squidS15986Package declaration should match source file directory"CRITICAL*java:Î<p>By convention, a Java class' physical location (source directories) and its logical representation (packages) should be kept in sync. Thus a Java
file located at "src/org/sonarqube/Foo.java" should have a package of "org.sonarqube". </p>
<p>Unfortunately, this convention is not enforced by Java compilers, and nothing prevents a developer from making the "Foo.java" class part of the
"com.apple" package, which could degrade the maintainability of both the class and its application.</p>Z
CODE_SMELL
À
squid:S2201ª
squidS2201SReturn values should not be ignored when function calls don't have any side effects"MAJOR*java:√<p>When the call to a function doesn't have any side effects, what is the point of making the call if the results are ignored? In such case, either
the function call is useless and should be dropped or the source code doesn't behave as expected. </p>
<p>To prevent generating any false-positives, this rule triggers an issues only on the following predefined list of immutable classes in the Java API
: <code>String</code>, <code>Boolean</code>, <code>Integer</code>, <code>Double</code>, <code>Float</code>, <code>Byte</code>, <code>Character</code>,
<code>Short</code>, <code>StackTraceElement</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void handle(String command){
  command.toLowerCase(); // Noncompliant; result of method thrown away
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void handle(String command){
  String formattedCommand = command.toLowerCase();
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2012, 17.7 - The value returned by a function having non-void return type shall be used </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9YIRAQ">CERT, EXP12-C.</a> - Do not ignore values returned by functions </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/eoAyAQ">CERT, EXP12-CPP.</a> - Do not ignore values returned by functions or methods
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9gEqAQ">CERT, EXP00-J.</a> - Do not ignore values returned by methods </li>
</ul>ZBUG
¨

squid:S2444ú

squidS2444?Lazy initialization of "static" fields should be "synchronized""MAJOR*java:∏	<p>In a multi-threaded situation, un-<code>synchronized</code> lazy initialization of non-<code>volatile</code> fields could mean that a second thread
has access to a half-initialized object while the first thread is still creating it. Allowing such access could cause serious bugs. Instead. the
initialization block should be <code>synchronized</code> or the variable made <code>volatile</code>.</p>
<p>Similarly, updates of such fields should also be <code>synchronized</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
protected static Object instance = null;

public static Object getInstance() {
    if (instance != null) {
        return instance;
    }

    instance = new Object();  // Noncompliant
    return instance;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
protected static volatile Object instance = null;

public static Object getInstance() {
    if (instance != null) {
        return instance;
    }

    instance = new Object();
    return instance;
}
</pre>
<p>or </p>
<pre>
protected static Object instance = null;

public static synchronized Object getInstance() {
    if (instance != null) {
        return instance;
    }

    instance = new Object();
    return instance;
}
</pre>ZBUG
§
squid:S1596î
squidS1596I"Collections.EMPTY_LIST", "EMPTY_MAP", and "EMPTY_SET" should not be used"MINOR*java:ü<p>Since the introduction of generics in Java 5, the use of generic types such as <code>List&lt;String&gt;</code> is recommended over the use of raw
ones such as <code>List</code>. Assigning a raw type to a generic one is not type safe, and will generate a warning. The old <code>EMPTY_...</code>
fields of the <code>Collections</code> class return raw types, whereas the newer <code>empty...()</code> methods return generic ones.</p>
<h2>Noncompliant Code Example</h2>
<pre>
List&lt;String&gt; collection1 = Collections.EMPTY_LIST;  // Noncompliant
Map&lt;String, String&gt; collection2 = Collections.EMPTY_MAP;  // Noncompliant
Set&lt;String&gt; collection3 = Collections.EMPTY_SET;  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
List&lt;String&gt; collection1 = Collections.emptyList();
Map&lt;String, String&gt; collection2 = Collections.emptyMap();
Set&lt;String&gt; collection3 = Collections.emptySet();
</pre>Z
CODE_SMELL
Ì	
squid:S2441›	
squidS2441FNon-serializable objects should not be stored in "HttpSession" objects"MAJOR*java:Ú<p>If you have no intention of writting an <code>HttpSession</code> object to file, then storing non-<code>serializable</code> objects in it may not
seem like a big deal. But whether or not you explicitly serialize the session, it may be written to disk anyway, as the server manages its memory use
in a process called "passivation". Further, some servers automatically write their active sessions out to file at shutdown &amp; deserialize any such
sessions at startup.</p>
<p>The point is, that even though <code>HttpSession</code> does not <code>extend Serializable</code>, you must nonetheless assume that it will be
serialized, and understand that if you've stored non-serializable objects in the session, errors will result. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Address {
  //...
}

//...
HttpSession session = request.getSession();
session.setAttribute("address", new Address());  // Noncompliant; Address isn't serializable
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/579.html">MITRE, CWE-579</a> - J2EE Bad Practices: Non-serializable Object Stored in Session
  </li>
</ul>ZBUG
¸
squid:S2442Ï
squidS2442+"Lock" objects should not be "synchronized""MAJOR*java:ï<p><code>java.util.concurrent.locks.Lock</code> offers far more powerful and flexible locking operations than are available with
<code>synchronized</code> blocks. So synchronizing on a <code>Lock</code> throws away the power of the object, and is just silly. Instead, such
objects should be locked and unlocked using <code>tryLock()</code> and <code>unlock()</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Lock lock = new MyLockImpl();
synchronized(lock) {  // Noncompliant
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
Lock lock = new MyLockImpl();
lock.tryLock();
//...
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/cQCaAg">CERT, LCK03-J.</a> - Do not synchronize on the intrinsic locks of high-level
  concurrency objects </li>
</ul>Z
CODE_SMELL
Ü
squid:S2200ˆ
squidS2200="compareTo" results should not be checked for specific values"MINOR*java:î<p>While most <code>compareTo</code> methods return -1, 0, or 1, some do not, and testing the result of a <code>compareTo</code> against a specific
value other than 0 could result in false negatives.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (myClass.compareTo(arg) == -1) {  // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if (myClass.compareTo(arg) &lt; 0) {
  // ...
}
</pre>ZBUG
«

squid:S2681∑

squidS26813Multiline blocks should be enclosed in curly braces"MAJOR*java:ﬂ	<p>Curly braces can be omitted from a one-line block, such as with an <code>if</code> statement or <code>for</code> loop, but doing so can be
misleading and induce bugs. </p>
<p>This rule raises an issue when the indentation of the lines after a one-line block indicates an intent to include those lines in the block, but the
omission of curly braces means the lines will be unconditionally executed once.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (condition)
  firstActionInBlock();
  secondAction();  // Noncompliant; executed unconditionally
thirdAction();

String str = null;
for (int i = 0; i &lt; array.length; i++)
  str = array[i];
  doTheThing(str);  // Noncompliant; executed only on last array element
</pre>
<h2>Compliant Solution</h2>
<pre>
if (condition) {
  firstActionInBlock();
  secondAction();
}
thirdAction();

String str = null;
for (int i = 0; i &lt; array.length; i++) {
  str = array[i];
  doTheThing(str);
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/483.html">MITRE, CWE-483</a> - Incorrect Block Delimitation </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/3wHEAw">CERT, EXP52-J.</a> - Use braces for the body of an if, for, or while statement
  </li>
</ul>ZBUG
ö	
squid:S2440ä	
squidS2440=Classes with only "static" methods should not be instantiated"MAJOR*java:°<p><code>static</code> methods can be accessed without an instance of the enclosing class, so there's no reason to instantiate a class that has only
<code>static</code> methods.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class TextUtils {
  public static String stripHtml(String source) {
    return source.replaceAll("&lt;[^&gt;]+&gt;", "");
  }
}

public class TextManipulator {

  // ...

  public void cleanText(String source) {
    TextUtils textUtils = new TextUtils(); // Noncompliant

    String stripped = textUtils.stripHtml(source);

    //...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class TextUtils {
  public static String stripHtml(String source) {
    return source.replaceAll("&lt;[^&gt;]+&gt;", "");
  }
}

public class TextManipulator {

  // ...

  public void cleanText(String source) {
    String stripped = TextUtils.stripHtml(source);

    //...
  }
}
</pre>
<h2>See Also</h2>
<ul>
  <li> <a href='/coding_rules#rule_key=squid%3AS1118'>S1118</a> - Utility classes should not have public constructors </li>
</ul>Z
CODE_SMELL
Å
squid:NoSonarÔ
squidNoSonar Track uses of "NOSONAR" comments"MAJOR*java2S1291:ö<p>Any issue to quality rule can be deactivated with the <code>NOSONAR</code> marker. This marker is pretty useful to exclude false-positive results
but it can also be used abusively to hide real quality flaws.</p>
<p>This rule raises an issue when <code>NOSONAR</code> is used.</p>Z
CODE_SMELL
≤
squid:S3419¢
squidS3419+Group ids should follow a naming convention"MINOR*java:À<p>Shared naming conventions allow teams to collaborate effectively. This rule raises an issue when the a pom's <code>groupId</code> does not match
the provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression: <code>(com|org)(\.[a-z][a-z-0-9]*)+</code></p>
<pre>
&lt;project ...&gt;
  &lt;groupId&gt;myCo&lt;/groupId&gt;  &lt;!-- Noncompliant --&gt;

  &lt;!-- ... --&gt;
&lt;/project&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
&lt;project ...&gt;
  &lt;groupId&gt;com.myco&lt;/groupId&gt;

  &lt;!-- ... --&gt;
&lt;/project&gt;
</pre>Z
CODE_SMELL
„
squid:S2209”
squidS2209."static" members should be accessed statically"MAJOR*java:˘<p>While it is <em>possible</em> to access <code>static</code> members from a class instance, it's bad form, and considered by most to be misleading
because it implies to the readers of your code that there's an instance of the member per class instance.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class A {
  public static int counter = 0;
}

public class B {
  private A first = new A();
  private A second = new A();

  public void runUpTheCount() {
    first.counter ++;  // Noncompliant
    second.counter ++;  // Noncompliant. A.counter is now 2, which is perhaps contrary to expectations
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class A {
  public static int counter = 0;
}

public class B {
  private A first = new A();
  private A second = new A();

  public void runUpTheCount() {
    A.counter ++;  // Compliant
    A.counter ++;  // Compliant
  }
}
</pre>Z
CODE_SMELL
†
squid:S3417ê
squidS3417%Track uses of disallowed dependencies"MAJOR*java:Ω<p>Whether they are disallowed locally for security, license, or dependability reasons, forbidden dependencies should not be used. </p>
<p>This rule raises an issue when the group or artifact id of a direct dependency matches the configured forbidden dependency pattern. </p>
<h2>Noncompliant Code Example</h2>
<p>With a parameter of: <code>*:.*log4j.*</code></p>
<pre>
&lt;dependency&gt; &lt;!-- Noncompliant --&gt;
    &lt;groupId&gt;log4j&lt;/groupId&gt;
    &lt;artifactId&gt;log4j&lt;/artifactId&gt;
    &lt;version&gt;1.2.17&lt;/version&gt;
&lt;/dependency&gt;
</pre>@Z
CODE_SMELL
“
squid:S2208¬
squidS2208#Wildcard imports should not be used"CRITICAL*java:<p>Blindly importing all the classes in a package clutters the class namespace and could lead to conflicts between classes in different packages with
the same name. On the other hand, specifically listing the necessary classes avoids that problem and makes clear which versions were wanted.</p>
<h2>Noncompliant Code Example</h2>
<pre>
import java.sql.*; // Noncompliant
import java.util.*; // Noncompliant

private Date date; // Date class exists in java.sql and java.util. Which one is this?
</pre>
<h2>Compliant Solution</h2>
<pre>
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;

private Date date;
</pre>
<h2>Exceptions</h2>
<p>Static imports are ignored by this rule. E.G.</p>
<pre>
import static java.lang.Math.*;
</pre>Z
CODE_SMELL
Ö
squid:S1118ı
squidS11183Utility classes should not have public constructors"MAJOR*java:ñ<p>Utility classes, which are a collection of static members, are not meant to be instantiated.</p>
<p>Even abstract utility classes, which can be extended, should not have public constructors.</p>
<p>Java adds an implicit public constructor to every class which does not define at least one explicitly.</p>
<p>Hence, at least one non-public constructor should be defined.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class StringUtils { // Noncompliant

  public static String concatenate(String s1, String s2) {
    return s1 + s2;
  }

}
</pre>
<h2>Compliant Solution</h2>
<pre>
class StringUtils { // Compliant

  private StringUtils() {
    throw new IllegalAccessError("Utility class");
  }

  public static String concatenate(String s1, String s2) {
    return s1 + s2;
  }

}
</pre>Z
CODE_SMELL
î
squid:S2447Ñ
squidS24473Null should not be returned from a "Boolean" method"CRITICAL*java:¢<p>While <code>null</code> is technically a valid <code>Boolean</code> value, that fact, and the distinction between <code>Boolean</code> and
<code>boolean</code> is easy to forget. So returning <code>null</code> from a <code>Boolean</code> method is likely to cause problems with callers'
code.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public Boolean isUsable() {
  // ...
  return null;  // Noncompliant
}
</pre>Z
CODE_SMELL
û
squid:S2326é
squidS2326(Unused type parameters should be removed"MAJOR*java:∫<p>Type parameters that aren't used are dead code, which can only distract and possibly confuse developers during maintenance. Therefore, unused type
parameters should be removed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int &lt;T&gt; Add(int a, int b) // Noncompliant; &lt;T&gt; is ignored
{
  return a + b;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
int Add(int a, int b)
{
  return a + b;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>Z
CODE_SMELL
õ
squid:S3658ã
squidS3658"Unit tests should throw exceptions"MINOR*java:Ω<p>When the code under test in a unit test throws an exception, the test itself fails. Therefore, there is no need to surround the tested code with a
<code>try</code>-<code>catch</code> structure to detect failure. Instead, you can simply move the exception type to the method signature. </p>
<p>This rule raises an issue when there is a fail assertion inside a <code>catch</code> block.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@Test
public void testMethod() {
  try {
            // Some code
  } catch (MyException e) {
    Assert.fail(e.getMessage());  // Noncompliant
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@Test
public void testMethod() throws MyException {
    // Some code
}
</pre>Z
CODE_SMELL
€
squid:S1479À
squidS1479;"switch" statements should not have too many "case" clauses"MAJOR*java:‰<p>When <code>switch</code> statements have large sets of <code>case</code> clauses, it is usually an attempt to map two sets of data. A real map
structure would be more readable and maintainable, and should be used instead.</p>Z
CODE_SMELL
ó
squid:UselessImportCheck˙
squidUselessImportCheck!Useless imports should be removed"MINOR*java2S1128:ô<p>The imports part of a file should be handled by the Integrated Development Environment (IDE), not manually by the developer.</p>
<p>Unused and useless imports should not occur if that is the case.</p>
<p>Leaving them in reduces the code's readability, since their presence can be confusing.</p>
<h2>Noncompliant Code Example</h2>
<pre>
package my.company;

import java.lang.String;        // Noncompliant; java.lang classes are always implicitly imported
import my.company.SomeClass;    // Noncompliant; same-package files are always implicitly imported
import java.io.File;            // Noncompliant; File is not used

import my.company2.SomeType;
import my.company2.SomeType;    // Noncompliant; 'SomeType' is already imported

class ExampleClass {

  public String someString;
  public SomeType something;

}
</pre>
<h2>Exceptions</h2>
<p>Imports for types mentioned in comments, such as Javadocs, are ignored.</p>Z
CODE_SMELL
ø
squid:UnusedPrivateMethod°
squidUnusedPrivateMethod*Unused "private" methods should be removed"MAJOR*java2S1144:∂<p><code>private</code> methods that are never executed are dead code: unnecessary, inoperative code that should be removed. Cleaning out dead code
decreases the size of the maintained codebase, making it easier to understand the program and preventing bugs from being introduced.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo implements Serializable
{
  private Foo(){}     //Compliant, private empty constructor intentionally used to prevent any direct instantiation of a class.
  public static void doSomething(){
    Foo foo = new Foo();
    ...
  }
  private void unusedPrivateMethod(){...}
  private void writeObject(ObjectOutputStream s){...}  //Compliant, relates to the java serialization mechanism
  private void readObject(ObjectInputStream in){...}  //Compliant, relates to the java serialization mechanism
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo implements Serializable
{
  private Foo(){}     //Compliant, private empty constructor intentionally used to prevent any direct instantiation of a class.
  public static void doSomething(){
    Foo foo = new Foo();
    ...
  }

  private void writeObject(ObjectOutputStream s){...}  //Compliant, relates to the java serialization mechanism

  private void readObject(ObjectInputStream in){...}  //Compliant, relates to the java serialization mechanism
}
</pre>
<h2>Exceptions</h2>
<p>This rule doesn't raise any issue on annotated methods.</p>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/OYIyAQ">CERT, MSC07-CPP.</a> - Detect and remove dead code </li>
</ul>Z
CODE_SMELL
ö
squid:UselessParenthesesCheck¯
squidUselessParenthesesCheckXUseless parentheses around expressions should be removed to prevent any misunderstanding"MINOR*java2S1110:€<p>Useless parentheses can sometimes be misleading and so should be removed. </p>
<h2>Noncompliant Code Example</h2>
<pre>
return 3;
return (x);           // Noncompliant
return (x + 1);       // Noncompliant
int x = (y / 2 + 1);  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
return 3;
return x;
return x + 1;
int x = y / 2 + 1;
</pre>Z
CODE_SMELL
Ú
squid:S2698‚
squidS2698(JUnit assertions should include messages"MINOR*java:é<p>Adding messages to JUnit assertions is an investment in your future productivity. Spend a few seconds writing them now, and you'll save a lot of
time on the other end when either the tests fail and you need to quickly diagnose the problem, or when you need to maintain the tests and the
assertion messages work as a sort of documentation.</p>
<h2>Noncompliant Code Example</h2>
<pre>
assertEquals(4, list.size());  // Noncompliant

try {
  fail();  // Noncompliant
} catch (Exception e) {
  assertThat(list.get(0)).isEqualTo("pear");  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
assertEquals("There should have been 4 Fruits in the list", 4, list.size());

try {
  fail("And exception is expected here");
} catch (Exception e) {
  assertThat(list.get(0)).as("check first element").overridingErrorMessage("The first element should be a pear, not a %s", list.get(0)).isEqualTo("pear");
}
</pre>Z
CODE_SMELL
•
squid:S1126ï
squidS1126TReturn of boolean expressions should not be wrapped into an "if-then-else" statement"MINOR*java:ï<p>Return of boolean literal statements wrapped into <code>if-then-else</code> ones should be simplified.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (expression) {
  return true;
} else {
  return false;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
return expression;
</pre>Z
CODE_SMELL
Ï
squid:S2699‹
squidS2699Tests should include assertions"BLOCKER*java:è<p>A test case without assertions ensures only that no exceptions are thrown. Beyond basic runnability, it ensures nothing about the behavior of the
code under test.</p>
<p>This rule raises an exception when no assertions are found in a JUnit test.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@Test
public void testDoSomething() {  // Noncompliant
  MyClass myClass = new MyClass();
  myClass.doSomething();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@Test
public void testDoSomething() {
  MyClass myClass = new MyClass();
  assertNull(myClass.doSomething());  // JUnit assertion
  assertThat(myClass.doSomething()).isNull();  // Fest assertion
}
</pre>Z
CODE_SMELL
î
squid:S3546Ñ
squidS3546!Custom resources should be closed"BLOCKER*java:∫<p>Leaking resources in an application is never a good idea, as it can lead to memory issues, and even the crash of the application. This rule
template allows you to specify which constructions open a resource and how it is closed in order to raise issue within a method scope when custom
resources are leaked.</p>
<h2>See also</h2>
<ul>
  <li> <a href='/coding_rules#rule_key=squid%3AS2095'>S2095</a> - Resources should be closed </li>
</ul>@ZBUG
≠
squid:S1488ù
squidS1488NLocal Variables should not be declared and then immediately returned or thrown"MINOR*java:£<p>Declaring a variable only to immediately return or throw it is a bad practice.</p>
<p>Some developers argue that the practice improves code readability, because it enables them to explicitly name what is being returned. However, this
variable is an internal implementation detail that is not exposed to the callers of the method. The method name should be sufficient for callers to
know exactly what will be returned.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public long computeDurationInMilliseconds() {
  long duration = (((hours * 60) + minutes) * 60 + seconds ) * 1000 ;
  return duration;
}

public void doSomething() {
  RuntimeException myException = new RuntimeException();
  throw myException;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public long computeDurationInMilliseconds() {
  return (((hours * 60) + minutes) * 60 + seconds ) * 1000 ;
}

public void doSomething() {
  throw new RuntimeException();
}
</pre>Z
CODE_SMELL
≈
squid:S1125µ
squidS1125(Boolean literals should not be redundant"MINOR*java:·<p>Redundant Boolean literals should be removed from expressions to improve readability.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (booleanMethod() == true) { /* ... */ }
if (booleanMethod() == false) { /* ... */ }
if (booleanMethod() || false) { /* ... */ }
doSomething(!false);
doSomething(booleanMethod() == true);

booleanVariable = booleanMethod() ? true : false;
booleanVariable = booleanMethod() ? true : exp;
booleanVariable = booleanMethod() ? false : exp;
booleanVariable = booleanMethod() ? exp : true;
booleanVariable = booleanMethod() ? exp : false;
</pre>
<h2>Compliant Solution</h2>
<pre>
if (booleanMethod()) { /* ... */ }
if (!booleanMethod()) { /* ... */ }
if (booleanMethod()) { /* ... */ }
doSomething(true);
doSomething(booleanMethod());

booleanVariable = booleanMethod();
booleanVariable = booleanMethod() || exp;
booleanVariable = !booleanMethod() &amp;&amp; exp;
booleanVariable = !booleanMethod() || exp;
booleanVariable = booleanMethod() &amp;&amp; exp;
</pre>Z
CODE_SMELL
¬
squid:S3422≤
squidS3422+Dependencies should not have "system" scope"CRITICAL*java:ﬂ<p><code>system</code> dependencies are sought at a specific, specified path. This drastically reduces portability because if you deploy your artifact
in an environment that's not configured just like yours is, your code won't work. </p>
<h2>Noncompliant Code Example</h2>
<pre>
&lt;dependency&gt;
  &lt;groupId&gt;javax.sql&lt;/groupId&gt;
  &lt;artifactId&gt;jdbc-stdext&lt;/artifactId&gt;
  &lt;version&gt;2.0&lt;/version&gt;
  &lt;scope&gt;system&lt;/scope&gt;  &lt;!-- Noncompliant --&gt;
  &lt;systemPath&gt;/usr/bin/lib/rt.jar&lt;/systemPath&gt;  &lt;!-- remove this --&gt;
&lt;/dependency&gt;
</pre>ZBUG
¬
squid:S2696≤
squidS26964Instance methods should not write to "static" fields"CRITICAL*java:œ<p>Correctly updating a <code>static</code> field from a non-static method is tricky to get right and could easily lead to bugs if there are multiple
class instances and/or multiple threads in play. Ideally, <code>static</code> fields are only updated from <code>synchronized static</code>
methods.</p>
<p>This rule raises an issue each time a <code>static</code> field is updated from a non-static method.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  private static int count = 0;

  public void doSomething() {
    //...
    count++;  // Noncompliant
  }
}
</pre>Z
CODE_SMELL
·
squid:S2333—
squidS2333&Redundant modifiers should not be used"MINOR*java:ˇ<p>The methods declared in an <code>interface</code> are <code>public</code> and <code>abstract</code> by default. Any variables are automatically
<code>public static final</code>. There is no need to explicitly declare them so.</p>
<p>Since annotations are implicitly interfaces, the same holds true for them as well.</p>
<p>Similarly, the <code>final</code> modifier is redundant on any method of a <code>final</code> class, and <code>private</code> is redundant on the
constructor of an <code>Enum</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public interface Vehicle {

  public void go(int speed, Direction direction);  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
public interface Vehicle {

  void go(int speed, Direction direction);
</pre>Z
CODE_SMELL
Œ
squid:S3423æ
squidS3423/pom elements should be in the recommended order"MINOR*java:„
<p>The POM Code Convention convention recommends listing modifiers in the following order:</p>
<ol>
  <li> &lt;modelVersion/&gt; </li>
  <li> &lt;parent/&gt; </li>
  <li> &lt;groupId/&gt; </li>
  <li> &lt;artifactId/&gt; </li>
  <li> &lt;version/&gt; </li>
  <li> &lt;packaging/&gt; </li>
  <li> &lt;name/&gt; </li>
  <li> &lt;description/&gt; </li>
  <li> &lt;url/&gt; </li>
  <li> &lt;inceptionYear/&gt; </li>
  <li> &lt;organization/&gt; </li>
  <li> &lt;licenses/&gt; </li>
  <li> &lt;developers/&gt; </li>
  <li> &lt;contributors/&gt; </li>
  <li> &lt;mailingLists/&gt; </li>
  <li> &lt;prerequisites/&gt; </li>
  <li> &lt;modules/&gt; </li>
  <li> &lt;scm/&gt; </li>
  <li> &lt;issueManagement/&gt; </li>
  <li> &lt;ciManagement/&gt; </li>
  <li> &lt;distributionManagement/&gt; </li>
  <li> &lt;properties/&gt; </li>
  <li> &lt;dependencyManagement/&gt; </li>
  <li> &lt;dependencies/&gt; </li>
  <li> &lt;repositories/&gt; </li>
  <li> &lt;pluginRepositories/&gt; </li>
  <li> &lt;build/&gt; </li>
  <li> &lt;reporting/&gt; </li>
  <li> &lt;profiles/&gt; </li>
</ol>
<p>Not following this convention has no technical impact, but will reduce the pom's readability because most developers are used to the standard
order.</p>
<h2>See</h2>
<ul>
  <li> <a href="https://maven.apache.org/developers/conventions/code.html#POM_Code_Convention">POM Code Convention</a> </li>
</ul>Z
CODE_SMELL
»
squid:S1244∏
squidS12448Floating point numbers should not be tested for equality"MAJOR*java:€<p>Floating point math is imprecise because of the challenges of storing such values in a binary representation. Even worse, floating point math is
not associative; push a <code>float</code> or a <code>double</code> through a series of simple mathematical operations and the answer will be
different based on the order of those operation because of the rounding that takes place at each step.</p>
<p>Even simple floating point assignments are not simple:</p>
<pre>
float f = 0.1; // 0.100000001490116119384765625
double d = 0.1; // 0.1000000000000000055511151231257827021181583404541015625
</pre>
<p>(Results will vary based on compiler and compiler settings);</p>
<p>Therefore, the use of the equality (<code>==</code>) and inequality (<code>!=</code>) operators on <code>float</code> or <code>double</code> values
is almost always an error, and the use of other comparison operators (<code>&gt;</code>, <code>&gt;=</code>, <code>&lt;</code>, <code>&lt;=</code>) is
also problematic because they don't work properly for -0 and <code>NaN</code>. </p>
<p>Instead the best course is to avoid floating point comparisons altogether. When that is not possible, you should consider using one of Java's
float-handling <code>Numbers</code> such as <code>BigDecimal</code> which can properly handle floating point comparisons. A third option is to look
not for equality but for whether the value is close enough. I.e. compare the absolute value of the difference between the stored value and the
expected value against a margin of acceptable error. Note that this does not cover all cases (<code>NaN</code> and <code>Infinity</code> for
instance).</p>
<p>This rule checks for the use of direct and indirect equality/inequailty tests on floats and doubles.</p>
<h2>Noncompliant Code Example</h2>
<pre>
float myNumber = 3.146;
if ( myNumber == 3.146f ) { //Noncompliant. Because of floating point imprecision, this will be false
  // ...
}
if ( myNumber != 3.146f ) { //Noncompliant. Because of floating point imprecision, this will be true
  // ...
}

if (myNumber &lt; 4 || myNumber &gt; 4) { // Noncompliant; indirect inequality test
  // ...
}

float zeroFloat = 0.0f;
if (zeroFloat == 0) {  // Noncompliant. Computations may end up with a value close but not equal to zero.
}
</pre>
<h2>Exceptions</h2>
<p>Since <code>NaN</code> is not equal to itself, the specific case of testing a floating point value against itself is a valid test for
<code>NaN</code> and is therefore ignored.</p>
<pre>
float f;
double d;
if(f != f) { // Compliant; test for NaN value
  System.out.println("f is NaN");
} else if (f != d) { // Noncompliant
  // ...
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 13.3 - Floating-point expressions shall not be tested for equality or inequality. </li>
  <li> MISRA C++:2008, 6-2-2 - Floating-point expressions shall not be directly or indirectly tested for equality or inequality </li>
</ul>ZBUG
∫
squid:S3420™
squidS3420.Artifact ids should follow a naming convention"MINOR*java:–<p>Shared naming conventions allow teams to collaborate effectively. This rule raises an issue when a pom's <code>artifactId</code> does not match the
provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression: <code>[a-z][a-z-0-9]+</code></p>
<pre>
&lt;project ...&gt;
  &lt;artifactId&gt;My_Project&lt;/artifactId&gt;  &lt;!-- Noncompliant --&gt;

  &lt;!-- ... --&gt;
&lt;/project&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
&lt;project ...&gt;
  &lt;artifactId&gt;my-project&lt;/artifactId&gt;

  &lt;!-- ... --&gt;
&lt;/project&gt;
</pre>Z
CODE_SMELL
ˇ
squid:S2694Ô
squidS2694LInner classes which do not reference their owning classes should be "static""MINOR*java:˛<p>A non-static inner class has a reference to its outer class, and access to the outer class' fields and methods. That class reference makes the
inner class larger and could cause the outer class instance to live in memory longer than necessary. </p>
<p>If the reference to the outer class isn't used, it is more efficient to make the inner class <code>static</code> (also called nested). If the
reference is used only in the class constructor, then explicitly pass a class reference to the constructor. If the inner class is anonymous, it will
also be necessary to name it. </p>
<p>However, while a nested/<code>static</code> class would be more efficient, it's worth nothing that there are semantic differences between an inner
class and a nested one:</p>
<ul>
  <li> an inner class can only be instantiated within the context of an instance of the outer class. </li>
  <li> a nested (<code>static</code>) class can be instantiated independently of the outer class. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit {
  // ...

  public class Seed {  // Noncompliant; there's no use of the outer class reference so make it static
    int germinationDays = 0;
    public Seed(int germinationDays) {
      this.germinationDays = germinationDays;
    }
    public int getGerminationDays() {
      return germinationDays;
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Fruit {
  // ...

  public static class Seed {
    int germinationDays = 0;
    public Seed(int germinationDays) {
      this.germinationDays = germinationDays;
    }
    public int getGerminationDays() {
      return germinationDays;
    }
  }
}
</pre>ZBUG
“
squid:S3421¬
squidS34211Deprecated "${pom}" properties should not be used"MINOR*java:Â<p>Deprecated features are those that have been retained temporarily for backward compatibility, but which will eventually be removed. In effect,
deprecation announces a grace period to allow the smooth transition from the old features to the new ones. In that period, no use of the deprecated
features should be added, and all existing uses should be gradually removed.</p>
<p>This rule raises an issue when <code>${pom.*</code>} properties are used in a pom.</p>
<h2>Noncompliant Code Example</h2>
<pre>
  &lt;build&gt;
    &lt;finalName&gt;${pom.artifactId}-${pom.version}&lt;/finalName&gt;  &lt;!-- Noncompliant --&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
  &lt;build&gt;
    &lt;finalName&gt;${project.artifactId}-${project.version}&lt;/finalName&gt;
</pre>
<p>or</p>
<pre>
  &lt;build&gt;
    &lt;finalName&gt;${artifactId}-${version}&lt;/finalName&gt;
</pre>Z
CODE_SMELL
Á
squid:S2695◊
squidS2695O"PreparedStatement" and "ResultSet" methods should be called with valid indices"BLOCKER*java:·<p>The parameters in a <code>PreparedStatement</code> are numbered from 1, not 0, so using any "set" method of a <code>PreparedStatement</code> with a
number less than 1 is a bug, as is using an index higher than the number of parameters. Similarly, <code>ResultSet</code> indices also start at 1,
rather than 0</p>
<h2>Noncompliant Code Example</h2>
<pre>
PreparedStatement ps = con.prepareStatement("SELECT fname, lname FROM employees where hireDate &gt; ? and salary &lt; ?");
ps.setDate(0, date);  // Noncompliant
ps.setDouble(3, salary);  // Noncompliant

ResultSet rs = ps.executeQuery();
while (rs.next()) {
  String fname = rs.getString(0);  // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
PreparedStatement ps = con.prepareStatement("SELECT fname, lname FROM employees where hireDate &gt; ? and salary &lt; ?");
ps.setDate(1, date);
ps.setDouble(2, salary);

ResultSet rs = ps.executeQuery();
while (rs.next()) {
  String fname = rs.getString(1);
  // ...
}
</pre>ZBUG
∑

squid:S2692ß

squidS26923"indexOf" checks should not be for positive numbers"MINOR*java:œ	<p>Most checks against an <code>indexOf</code> value compare it with -1 because 0 is a valid index. Any checks which look for values &gt;0 ignore the
first element, which is likely a bug. If the intent is merely to check inclusion of a value in a <code>String</code> or a <code>List</code>, consider
using the <code>contains</code> method instead.</p>
<p>This rule raises an issue when an <code>indexOf</code> value retrieved either from a <code>String</code> or a <code>List</code> is tested against
<code>&gt;0</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String color = "blue";
String name = "ishmael";

List&lt;String&gt; strings = new ArrayList&lt;String&gt; ();
strings.add(color);
strings.add(name);

if (strings.indexOf(color) &gt; 0) {  // Noncompliant
  // ...
}
if (name.indexOf("ish") &gt; 0) { // Noncompliant
  // ...
}
if (name.indexOf("ae") &gt; 0) { // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
String color = "blue";
String name = "ishmael";

List&lt;String&gt; strings = new ArrayList&lt;String&gt; ();
strings.add(color);
strings.add(name);

if (strings.indexOf(color) &gt; -1) {
  // ...
}
if (name.indexOf("ish") &gt;= 0) {
  // ...
}
if (name.contains("ae") {
  // ...
}
</pre>ZBUG
»
squid:S2693∏
squidS2693-Threads should not be started in constructors"BLOCKER*java:›<p>The problem with invoking <code>Thread.start()</code> in a constructor is that you'll have a confusing mess on your hands if the class is ever
extended because the superclass' constructor will start the thread before the child class has truly been initialized.</p>
<p>This rule raises an issue any time <code>start</code> is invoked in the constructor of a non-<code>final</code> class.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  Thread thread = null;

  public MyClass(Runnable runnable) {
    thread = new Thread(runnable);
    thread.start(); // Noncompliant
  }
}
</pre>Z
CODE_SMELL
ô
squid:S3306â
squidS3306?Constructor injection should be used instead of field injection"MAJOR*java:•
<p>Field injection seems like a tidy way to get your classes what they need to do their jobs, but it's really a <code>NullPointerException</code>
waiting to happen unless all your class constructors are <code>private</code>. That's because any class instances that are constructed by callers,
rather than instantiated by the Spring framework, won't have the ability to perform the field injection.</p>
<p>Instead <code>@Inject</code> should be moved to the constructor and the fields required as constructor parameters.</p>
<p>This rule raises an issue when classes with non-<code>private</code> constructors (including the default constructor) use field injection.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyComponent {  // Anyone can call the default constructor

  @Inject MyCollaborator collaborator;  // Noncompliant

  public void myBusinessMethod() {
    collaborator.doSomething();  // this will fail in classes new-ed by a caller
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyComponent {

  private final MyCollaborator collaborator;

  @Inject
  public MyComponent(MyCollaborator collaborator) {
    Assert.notNull(collaborator, "MyCollaborator must not be null!");
    this.collaborator = collaborator;
  }

  public void myBusinessMethod() {
    collaborator.doSomething();
  }
}
</pre>ZBUG
¨
squid:S1481ú
squidS1481(Unused local variables should be removed"MINOR*java:»<p>If a local variable is declared but not used, it is dead code and should be removed. Doing so will improve maintainability because developers will
not wonder what the variable is used for.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int numberOfMinutes(int hours) {
  int seconds = 0;   // seconds is never used
  return hours * 60;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public int numberOfMinutes(int hours) {
  return hours * 60;
}
</pre>Z
CODE_SMELL
≈
squid:S2148µ
squidS21489Underscores should be used to make large numbers readable"MINOR*java:–
<p>Beginning with Java 7, it is possible to add underscores ('_') to numeric literals to enhance readability. The addition of underscores in this
manner has no semantic meaning, but makes it easier for maintainers to understand the code.</p>
<p>The number of digits to the left of a decimal point needed to trigger this rule varies by base.</p>
<table>
  <tbody>
    <tr>
      <th>Base</th>
      <th> Minimum digits</th>
      <th> Ideal spacing</th>
    </tr>
    <tr>
      <td>binary</td>
      <td> 9 </td>
      <td> every 8 </td>
    </tr>
    <tr>
      <td>decimal</td>
      <td> 5 </td>
      <td> every 3</td>
    </tr>
    <tr>
      <td>hexadecimal</td>
      <td> 9 </td>
      <td> every 4</td>
    </tr>
  </tbody>
</table>
<p>It is only the presence of underscores, not their spacing that is scrutinized by this rule.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>7</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int i = 10000000;  // Noncompliant; is this 10 million or 100 million?
int  j = 0b01101001010011011110010101011110;  // Noncompliant
long l = 0x7fffffffffffffffL;  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
int i = 10_000_000;
int  j = 0b01101001_01001101_11100101_01011110;
long l = 0x7fff_ffff_ffff_ffffL;
</pre>Z
CODE_SMELL
ë
squid:S2388Å
squidS2388>Inner class calls to super class methods should be unambiguous"MAJOR*java:ó<p>When an inner class extends another class, and both its outer class and its parent class have a method with the same name, calls to that method can
be confusing. The compiler will resolve the call to the superclass method, but maintainers may be confused, so the superclass method should be called
explicitly, using <code>super.</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Parent {
  public void foo() { ... }
}

public class Outer {

  public void foo() { ... }

  public class Inner extends Parent {

    public void doTheThing() {
      foo();  // Noncompliant; was Outer.this.foo() intended instead?
      // ...
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Parent {
  public void foo() { ... }
}

public class Outer {

  public void foo() { ... }

  public class Inner extends Parent {

    public void doTheThing() {
      super.foo();
      // ...
    }
  }
}
</pre>Z
CODE_SMELL
œ
squid:S3599ø
squidS3599.Double Brace Initialization should not be used"MINOR*java:Ï<p>Because Double Brace Initialization (DBI) creates an anonymous class with a reference to the instance of the owning object, its use can lead to
memory leaks if the anonymous inner class is returned and held by other objects. Even when there's no leak, DBI is so obscure that it's bound to
confuse most maintainers. </p>
<p>For collections, use <code>Arrays.asList</code> instead, or explicitly add each item directly to the collection.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Map source = new HashMap(){{ // Noncompliant
    put("firstName", "John");
    put("lastName", "Smith");
}};
</pre>
<h2>Compliant Solution</h2>
<pre>
Map source = new HashMap();
// ...
source.put("firstName", "John");
source.put("lastName", "Smith");
// ...
</pre>ZBUG
ı
squid:S2147Â
squidS2147Catches should be combined"MINOR*java:ü<p>Since Java 7 it has been possible to catch multiple exceptions at once. Therefore, when multiple <code>catch</code> blocks have the same code, they
should be combined for better readability.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>7</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
catch (IOException e) {
  doCleanup();
  logger.log(e);
}
catch (SQLException e) {  // Noncompliant
  doCleanup();
  logger.log(e);
}
catch (TimeoutException e) {  // Compliant; block contents are different
  doCleanup();
  throw e;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
catch (IOException|SQLException e) {
  doCleanup();
  logger.log(e);
}
catch (TimeoutException e) {
  doCleanup();
  throw e;
}
</pre>Z
CODE_SMELL
œ
squid:S2386ø
squidS2386,Mutable fields should not be "public static""MINOR*java:‰<p>There is no good reason to have a mutable object as the <code>public</code> (by default), <code>static</code> member of an <code>interface</code>.
Such variables should be moved into classes and their visibility lowered. </p>
<p>Similarly, mutable <code>static</code> members of classes and enumerations which are accessed directly, rather than through getters and setters,
should be protected to the degree possible. That can be done by reducing visibility or making the field <code>final</code> if appropriate. </p>
<p>Note that making a mutable field, such as an array, <code>final</code> will keep the variable from being reassigned, but doing so has no effect on
the mutability of the internal state of the array (i.e. it doesn't accomplish the goal).</p>
<p>This rule raises issues for <code>public static</code> array, <code>Collection</code>, <code>Date</code>, and <code>awt.Point</code> members.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public interface MyInterface {
  public static String [] strings; // Noncompliant
}

public class A {
  public static String [] strings1 = {"first","second"};  // Noncompliant
  public static String [] strings2 = {"first","second"};  // Noncompliant
  public static List&lt;String&gt; strings3 = new ArrayList&lt;&gt;();  // Noncompliant
  // ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/582.html">MITRE, CWE-582</a> - Array Declared Public, Final, and Static </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/607.html">MITRE, CWE-607</a> - Public Static Final Field References Mutable Object </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/rwBc">CERT, OBJ01-J.</a> - Limit accessibility of fields </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/JQLEAw">CERT, OBJ13-J.</a> - Ensure that references to mutable objects are not exposed
  </li>
</ul>ZVULNERABILITY
©
squid:S3355ô
squidS3355.Web applications should use validation filters"CRITICAL*java:π
<p>Specifying a validation filter for all input in your <code>web.xml</code> allows you to scrub all your HTTP parameters in one central place. To do
so, you'll need to define a validator, and a filtering class that uses it, then set up the filter's use in <code>web.xml</code>.</p>
<h2>Compliant Solution</h2>
<pre>
public class ValidatingHttpRequest extends HttpServletRequestWrapper {
  // ...
}

public class ValidationFilter implements javax.servlet.Filter {
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
    chain.doFilter(new ValidatingHttpRequest( (HttpServletRequest)request ), response);
  }
}
</pre>
<p>and</p>
<pre>
  &lt;filter&gt;
     &lt;filter-name&gt;ValidationFilter&lt;/filter-name&gt;
     &lt;filter-class&gt;com.myco.servlet.ValidationFilter&lt;/filter-class&gt;
  &lt;/filter&gt;

  &lt;filter-mapping&gt;
     &lt;filter-name&gt;ValidationFilter&lt;/filter-name&gt;
     &lt;url-pattern&gt;/*&lt;/url-pattern&gt;
  &lt;/filter-mapping&gt;
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A1-Injection">OWASP Top Ten 2013 Category A1</a> - Injection </li>
  <li> <a href="https://www.owasp.org/index.php/How_to_add_validation_logic_to_HttpServletRequest">OWASP, How to add validation logic to
  HttpServletRequest</a> </li>
</ul>ZVULNERABILITY
Ò	
squid:S2387·	
squidS23878Child class fields should not shadow parent class fields"BLOCKER*java:˚<p>Having a variable with the same name in two unrelated classes is fine, but do the same thing within a class hierarchy and you'll get confusion at
best, chaos at worst. Perhaps even worse is the case where a child class field varies from the name of a parent class only by case.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit {
  protected Season ripe;
  protected Color flesh;

  // ...
}

public class Raspberry extends Fruit {
  private boolean ripe;  // Noncompliant
  private static Color FLESH; // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Fruit {
  protected Season ripe;
  protected Color flesh;

  // ...
}

public class Raspberry extends Fruit {
  private boolean ripened;
  private static Color FLESH_COLOR;

}
</pre>
<h2>Exceptions</h2>
<p>This rule ignores <code>private</code> parent class fields, but in all other such cases, the child class field should be renamed.</p>
<pre>
public class Fruit {
  private Season ripe;
  // ...
}

public class Raspberry extends Fruit {
  private Season ripe;  // Compliant as parent field 'ripe' is anyway not visible from Raspberry
  // ...
}
</pre>Z
CODE_SMELL
√	
squid:S2142≥	
squidS2142,"InterruptedException" should not be ignored"MAJOR*java:‚<p><code>InterruptedExceptions</code> should never be ignored in the code, and simply logging the exception counts in this case as "ignoring".
Instead, <code>InterruptedExceptions</code> should either be rethrown - immediately or after cleaning up the method's state - or the method should be
reinterrupted. Any other course of action risks delaying thread shutdown and loses the information that the thread was interrupted - probably without
finishing its task.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void run () {
  try {
    while (true) {
      // do stuff
    }
  }catch (InterruptedException e) { // Noncompliant; logging is not enough
    LOGGER.log(Level.WARN, "Interrupted!", e);
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void run () {
  try {
    while (true) {
      // do stuff
    }
  }catch (InterruptedException e) {
    LOGGER.log(Level.WARN, "Interrupted!", e);
    // clean up state...
    Thread.currentThread().interrupt();
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/391.html">MITRE, CWE-391</a> - Unchecked Error Condition </li>
</ul>ZBUG
˝
squid:S1175Ì
squidS1175FThe signature of "finalize()" should match that of "Object.finalize()""CRITICAL*java:ˇ<p><code>Object.finalize()</code> is called by the Garbage Collector at some point after the object becomes unreferenced.</p>
<p>In general, overloading <code>Object.finalize()</code> is a bad idea because:</p>
<ul>
  <li> The overload may not be called by the Garbage Collector. </li>
  <li> Users are not expected to call <code>Object.finalize()</code> and will get confused. </li>
</ul>
<p>But beyond that it's a terrible idea to name a method "finalize" if it doesn't actually override <code>Object.finalize()</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int finalize(int someParameter) {        // Noncompliant
  /* ... */
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public int someBetterName(int someParameter) {  // Compliant
  /* ... */
}
</pre>ZBUG
í
squid:S1174Ç
squidS1174K"Object.finalize()" should remain protected (versus public) when overriding"CRITICAL*java:à<p>The contract of the <code>Object.finalize()</code> method is clear: only the Garbage Collector is supposed to call this method.</p>
<p>Making this method public is misleading, because it implies that any caller can use it.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  @Override
  public void finalize() {    // Noncompliant
    /* ... */
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/583.html">MITRE, CWE-583</a> - finalize() Method Declared Public </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/H4cbAQ">CERT, MET12-J.</a> - Do not use finalizers </li>
</ul>Z
CODE_SMELL
ö
squid:ClassCyclomaticComplexityˆ
squidClassCyclomaticComplexity!Classes should not be too complex"CRITICAL*java2S1311:ã<p>The Cyclomatic Complexity is measured by the number of <code>&amp;&amp;</code> and <code>||</code> operators and <code>if</code>,
<code>while</code>, <code>do</code>, <code>for</code>, <code>?:</code>, <code>catch</code>, <code>switch</code>, <code>case</code>,
<code>return</code> and <code>throw</code> statements in the body of a class plus one for each constructor, method, static initializer, or instance
initializer in the class. The last return statement in method, if exists, is not taken into account.</p>
<p>Even when the Cyclomatic Complexity of a class is very high, this complexity might be well distributed among all methods. Nevertheless, most of the
time, a very complex class is a class which breaks the Single Responsibility Principle and which should be re-factored to be split in several
classes.</p>
<h2>Deprecated</h2>
<p>This rule is deprecated, and will eventually be removed.</p>Z
CODE_SMELL
Â
squid:S2140’
squidS2140eMethods of "Random" that return floating point values should not be used in random integer generation"MINOR*java:À<p>There is no need to multiply the output of <code>Random</code>'s <code>nextDouble</code> method to get a random integer. Use the
<code>nextInt</code> method instead.</p>
<p>This rule raises an issue when the return value of any of <code>Random</code>'s methods that return a floating point value is converted to an
integer.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Random r = new Random();
int rand = (int)r.nextDouble() * 50;  // Noncompliant way to get a pseudo-random value between 0 and 50
int rand2 = (int)r.nextFloat(); // Noncompliant; will always be 0;
</pre>
<h2>Compliant Solution</h2>
<pre>
Random r = new Random();
int rand = r.nextInt(50);  // returns pseudo-random value between 0 and 50
</pre>ZBUG
Ï
squid:S2141‹
squidS2141CClasses that don't define "hashCode()" should not be used in hashes"MAJOR*java:Ù<p>Because <code>Object</code> implements <code>hashCode</code>, any Java class can be put into a hash structure. However, classes that define
<code>equals(Object)</code> but not <code>hashCode()</code> aren't truly hash-able because instances that are equivalent according to the
<code>equals</code> method can return different hashes.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Student {  // no hashCode() method; not hash-able
  // ...

  public boolean equals(Object o) {
    // ...
  }
}

public class School {
  private Map&lt;Student, Integer&gt; studentBody = // okay so far
          new HashTable&lt;Student, Integer&gt;(); // Noncompliant

  // ...
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Student {  // has hashCode() method; hash-able
  // ...

  public boolean equals(Object o) {
    // ...
  }
  public int hashCode() {
    // ...
  }
}

public class School {
  private Map&lt;Student, Integer&gt; studentBody = new HashTable&lt;Student, Integer&gt;();

  // ...
</pre>ZBUG
‚
squid:S1172“
squidS1172*Unused method parameters should be removed"MAJOR*java:¸
<p>Unused parameters are misleading. Whatever the value passed to such parameters is, the behavior will be the same.</p>
<h2>Noncompliant Code Example</h2>
<pre>
void doSomething(int a, int b) {     // "b" is unused
  compute(a);
}
</pre>
<h2>Compliant Solution</h2>
<pre>
void doSomething(int a) {
  compute(a);
}
</pre>
<h2>Exceptions</h2>
<p>Override and implementation methods are excluded, as are parameters annotated with <code>@Observes</code>, and methods that are intended to be
overridden.</p>
<pre>
@Override
void doSomething(int a, int b) {     // no issue reported on b
  compute(a);
}

public void foo(String s) {
  // designed to be extended but noop in standard case
}

protected void bar(String s) {
  //open-closed principle
}

public void qix(String s) {
  throw new UnsupportedOperationException("This method should be implemented in subclasses");
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C++:2008, 0-1-11 - There shall be no unused parameters (named or unnamed) in nonvirtual functions. </li>
  <li> MISRA C:2012, 2.7 - There should be no unused parameters in functions </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>Z
CODE_SMELL
Ò
squid:S1171·
squidS1171-Only static class initializers should be used"MAJOR*java:à<p>Non-static initializers are rarely used, and can be confusing for most developers because they only run when new class instances are created. When
possible, non-static initializers should be refactored into standard constructors or field initializers.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass {
  private static final Map&lt;String, String&gt; MY_MAP = new HashMap&lt;String, String&gt;() {

    // Noncompliant - HashMap should be extended only to add behavior, not for initialization
    {
      put("a", "b");
    }

  };
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {
  private static final Map&lt;String, String&gt; MY_MAP = new HashMap&lt;String, String&gt;();

  static {
    MY_MAP.put("a", "b");
  }
}
</pre>
<p>or using Guava:</p>
<pre>
class MyClass {
  // Compliant
  private static final Map&lt;String, String&gt; MY_MAP = ImmutableMap.of("a", "b");
}
</pre>Z
CODE_SMELL
Â
squid:S1170’
squidS1170jPublic constants and fields initialized at declaration should be "static final" rather than merely "final""MINOR*java:ø
<p>Making a <code>public</code> constant just <code>final</code> as opposed to <code>static final</code> leads to duplicating its value for every
instance of the class, uselessly increasing the amount of memory required to execute the application.</p>
<p>Further, when a non-<code>public</code>, <code>final</code> field isn't also <code>static</code>, it implies that different instances can have
different values. However, initializing a non-<code>static final</code> field in its declaration forces every instance to have the same value. So such
fields should either be made <code>static</code> or initialized in the constructor.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Myclass {
  public final int THRESHOLD = 3;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Myclass {
  public static final int THRESHOLD = 3;    // Compliant
}
</pre>
<h2>Exceptions</h2>
<p>No issues are reported on final fields of inner classes whose type is not a primitive or a String. Indeed according to the Java specification:</p>
<blockquote>
  <p>An inner class is a nested class that is not explicitly or implicitly declared static. Inner classes may not declare static initializers (¬ß8.7)
  or member interfaces. Inner classes may not declare static members, unless they are compile-time constant fields (¬ß15.28).</p>
</blockquote>Z
CODE_SMELL
Û
squid:S3369„
squidS3369&Security constraints should be defined"BLOCKER*java:å<p>Websphere, Tomcat, and JBoss web servers allow the definition of role-based access to servlets. It may not be granular enough for your purposes,
but it's a start, and should be used at least as a base.</p>
<p>This rule raises an issue when a <em>web.xml</em> file has no <code>&lt;security-contraint&gt;</code> elements.</p>
<h2>See</h2>
<ul>
  <li> <a href="https://cwe.mitre.org/data/definitions/284.html">MITRE, CWE-284</a> - Improper Access Control </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A7-Missing_Function_Level_Access_Control">OWASP Top Ten 2013 Category A7</a> - Missing
  Function Level Access Control </li>
</ul>ZVULNERABILITY
’
squid:S2159≈
squidS2159(Silly equality checks should not be made"MAJOR*java:¯<p>Comparisons of dissimilar types will always return false. The comparison and all its dependent code can simply be removed. This includes:</p>
<ul>
  <li> comparing an object with null </li>
  <li> comparing an object with an unrelated primitive (E.G. a string with an int) </li>
  <li> comparing unrelated classes </li>
  <li> comparing an unrelated <code>class</code> and <code>interface</code> </li>
  <li> comparing unrelated <code>interface</code> types </li>
  <li> comparing an array to a non-array </li>
  <li> comparing two arrays </li>
</ul>
<p>Specifically in the case of arrays, since arrays don't override <code>Object.equals()</code>, calling <code>equals</code> on two arrays is the same
as comparing their addresses. This means that <code>array1.equals(array2)</code> is equivalent to <code>array1==array2</code>.</p>
<p>However, some developers might expect <code>Array.equals(Object obj)</code> to do more than a simple memory address comparison, comparing for
instance the size and content of the two arrays. Instead, the <code>==</code> operator or <code>Arrays.equals(array1, array2)</code> should always be
used with arrays.</p>
<h2>Noncompliant Code Example</h2>
<pre>
interface KitchenTool { ... };
interface Plant {...}

public class Spatula implements KitchenTool { ... }
public class Tree implements Plant { ...}
//...

Spatula spatula = new Spatula();
KitchenTool tool = spatula;
KitchenTool [] tools = {tool};

Tree tree = new Tree();
Plant plant = tree;
Tree [] trees = {tree};


if (spatula.equals(tree)) { // Noncompliant; unrelated classes
  // ...
}
else if (spatula.equals(plant)) { // Noncompliant; unrelated class and interface
  // ...
}
else if (tool.equals(plant)) { // Noncompliant; unrelated interfaces
  // ...
}
else if (tool.equals(tools)) { // Noncompliant; array &amp; non-array
  // ...
}
else if (trees.equals(tools)) {  // Noncompliant; incompatible arrays
  // ...
}
else if (tree.equals(null)) {  // Noncompliant
  // ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/IQAlAg">CERT, EXP02-J.</a> - Do not use the Object.equals() method to compare two
  arrays </li>
</ul>ZBUG
ÿ
squid:S2039»
squidS2039.Member variable visibility should be specified"MINOR*java:Î<p>Failing to explicitly declare the visibility of a member variable could result it in having a visibility you don't expect, and potentially leave it
open to unexpected modification by other classes. </p>
<h2>Compliant Solution</h2>
<pre>
class Ball {
    private String color="red";  // Compliant
}
enum A {
  B;
  private int a;
}
</pre>
<h2>Exceptions</h2>
<p>Members annotated with Guava's <code>@VisibleForTesting</code> annotation are ignored, as it indicates that visibility has been purposely relaxed
to make the code testable.</p>
<pre>
class Cone {
  @VisibleForTesting
  Logger logger; // Compliant
}
</pre>ZVULNERABILITY
⁄

squid:S2157 

squidS2157%"Cloneables" should implement "clone""MAJOR*java:Ä
<p>Simply implementing <code>Cloneable</code> without also overriding <code>Object.clone()</code> does not necessarily make the class cloneable. While
the <code>Cloneable</code> interface does not include a <code>clone</code> method, it is required by convention, and ensures true cloneability.
Otherwise the default JVM <code>clone</code> will be used, which copies primitive values and object references from the source to the target. I.e.
without overriding <code>clone</code>, any cloned instances will potentially share members with the source instance.</p>
<p>Removing the <code>Cloneable</code> implementation and providing a good copy constructor is another viable (some say preferable) way of allowing a
class to be copied.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class Team implements Cloneable {  // Noncompliant
  private Person coach;
  private List&lt;Person&gt; players;
  public void addPlayer(Person p) {...}
  public Person getCoach() {...}
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class Team implements Cloneable {
  private Person coach;
  private List&lt;Person&gt; players;
  public void addPlayer(Person p) { ... }
  public Person getCoach() { ... }

  @Override
  public Object clone() {
    Team clone = (Team) super.clone();
    //...
  }
}
</pre>ZBUG
—
squid:S2278¡
squidS2278GNeither DES (Data Encryption Standard) nor DESede (3DES) should be used"BLOCKER*java:…<p>According to the US National Institute of Standards and Technology (NIST), the Data Encryption Standard (DES) is no longer considered secure:</p>
<blockquote>
  <p>Adopted in 1977 for federal agencies to use in protecting sensitive, unclassified information, the DES is being withdrawn because it no longer
  provides the security that is needed to protect federal government information.</p>
  <p>Federal agencies are encouraged to use the Advanced Encryption Standard, a faster and stronger algorithm approved as FIPS 197 in 2001.</p>
</blockquote>
<h2>Noncompliant Code Example</h2>
<pre>
Cipher c = Cipher.getInstance("DESede/ECB/PKCS5Padding");
</pre>
<h2>Compliant Solution</h2>
<pre>
Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/326.html">MITRE CWE-326</a> - Inadequate Encryption Strength </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/327.html">MITRE CWE-327</a> - Use of a Broken or Risky Cryptographic Algorithm </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/VwAZAg">CERT, MSC61-J.</a> - Do not use insecure or weak cryptographic algorithms </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#DES_USAGE">DES / DESede Unsafe</a> </li>
</ul>ZVULNERABILITY
¡
squid:S1068±
squidS1068)Unused "private" fields should be removed"MAJOR*java:‹<p>If a <code>private</code> field is declared but not used in the program, it can be considered dead code and should therefore be removed. This will
improve maintainability because developers will not wonder what the variable is used for.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {
  private int foo = 42;

  public int compute(int a) {
    return a * 42;
  }

}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {
  public int compute(int a) {
    return a * 42;
  }
}
</pre>
<h2>Exceptions</h2>
<p>The Java serialization runtime associates with each serializable class a version number, called <code>serialVersionUID</code>, which is used during
deserialization to verify that the sender and receiver of a serialized object have loaded classes for that object that are compatible with respect to
serialization.</p>
<p>A serializable class can declare its own <code>serialVersionUID</code> explicitly by declaring a field named <code>serialVersionUID</code> that
must be static, final, and of type long. By definition those <code>serialVersionUID</code> fields should not be reported by this rule:</p>
<pre>
public class MyClass implements java.io.Serializable {
  private static final long serialVersionUID = 42L;
}
</pre>
<p>Moreover, this rule doesn't raise any issue on annotated fields.</p>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>Z
CODE_SMELL
ç
squid:S2276˝
squidS2276M"wait(...)" should be used instead of "Thread.sleep(...)" when a lock is held"BLOCKER*java:â<p>If <code>Thread.sleep(...)</code> is called when the current thread holds a lock, it could lead to performance, and scalability issues, or even
worse to deadlocks because the execution of the thread holding the lock is frozen. It's better to call <code>wait(...)</code> on the monitor object to
temporarily release the lock and allow other threads to run.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething(){
  synchronized(monitor) {
    while(notReady()){
      Thread.sleep(200);
    }
    process();
  }
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(){
  synchronized(monitor) {
    while(notReady()){
      monitor.wait(200);
    }
    process();
  }
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/FgG7AQ">CERT, LCK09-J.</a> - Do not perform operations that can block while holding a
  lock </li>
</ul>ZBUG
⁄
squid:S1188 
squidS1188DLambdas and anonymous classes should not have too many lines of code"MAJOR*java:⁄<p>Anonymous classes and lambdas (with Java 8) are a very convenient and compact way to inject a behavior without having to create a dedicated class.
But those anonymous inner classes and lambdas should be used only if the behavior to be injected can be defined in a few lines of code, otherwise the
source code can quickly become unreadable.</p>Z
CODE_SMELL
æ
squid:S1067Æ
squidS1067%Expressions should not be too complex"CRITICAL*java:⁄<p>The complexity of an expression is defined by the number of <code>&amp;&amp;</code>, <code>||</code> and <code>condition ? ifTrue : ifFalse</code>
operators it contains.</p>
<p>A single expression's complexity should not become too high to keep the code readable.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold value of 3:</p>
<pre>
if (((condition1 &amp;&amp; condition2) || (condition3 &amp;&amp; condition4)) &amp;&amp; condition5) { ... }
</pre>
<h2>Compliant Solution</h2>
<pre>
if ( (myFirstCondition() || mySecondCondition()) &amp;&amp; myLastCondition()) { ... }
</pre>Z
CODE_SMELL
…
squid:S2156π
squidS21563"final" classes should not have "protected" members"MINOR*java:⁄
<p>The difference between <code>private</code> and <code>protected</code> visibility is that child classes can see and use <code>protected</code>
members, but they cannot see <code>private</code> ones. Since a <code>final</code> class will have no children, marking the members of a
<code>final</code> class <code>protected</code> is confusingly pointless.</p>
<p>Note that the <code>protected</code> members of a class can also be seen and used by other classes that are placed within the same package, this
could lead to accidental, unintended access to otherwise private members.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public final class MyFinalClass {

  protected String name = "Fred";  // Noncompliant
  protected void setName(String name) {  // Noncompliant
    // ...
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
public final class MyFinalClass {

  private String name = "Fred";
  public void setName(String name) {
    // ...
  }
</pre>
<h2>Exceptions</h2>
<p>Members annotated with Guava's <code>@VisibleForTesting</code> annotation are ignored, as it indicates that visibility has been purposely relaxed
to make the code testable.</p>
<pre>
public final class MyFinalClass {
  @VisibleForTesting
  protected Logger logger; // Compliant

  @VisibleForTesting
  protected int calculateSomethingComplex(String input) { // Compliant
    // ...
  }
}
</pre>Z
CODE_SMELL
ﬂ

squid:S2277œ

squidS2277cCryptographic RSA algorithms should always incorporate OAEP (Optimal Asymmetric Encryption Padding)"CRITICAL*java:∫	<p>Without OAEP in RSA encryption, it takes less work for an attacker to decrypt the data or infer patterns from the ciphertext. This rule logs an
issue as soon as a literal value starts with <code>RSA/NONE</code>. </p>
<h2>Noncompliant Code Example</h2>
<pre>
Cipher rsa = javax.crypto.Cipher.getInstance("RSA/NONE/NoPadding");
</pre>
<h2>Compliant Solution</h2>
<pre>
Cipher rsa = javax.crypto.Cipher.getInstance("RSA/ECB/OAEPWITHSHA-256ANDMGF1PADDING");
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/780.html">MITRE CWE-780</a> - Use of RSA Algorithm without OAEP </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/327.html">MITRE CWE-327</a>: Use of a Broken or Risky Cryptographic Algorithm </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A5-Security_Misconfiguration">OWASP Top Ten 2013 Category A5</a> - Security
  Misconfiguration </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#RSA_NO_PADDING">RSA NoPadding Unsafe</a> </li>
</ul>ZVULNERABILITY
ô
squid:S1066â
squidS1066,Collapsible "if" statements should be merged"MAJOR*java:±<p>Merging collapsible <code>if</code> statements increases the code's readability.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (file != null) {
  if (file.isFile() || file.isDirectory()) {
    /* ... */
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if (file != null &amp;&amp; isFileOrDirectory(file)) {
  /* ... */
}

private static boolean isFileOrDirectory(File file) {
  return file.isFile() || file.isDirectory();
}
</pre>Z
CODE_SMELL
≤	
squid:S2153¢	
squidS21536Boxing and unboxing should not be immediately reversed"MINOR*java:«<p>Boxing is the process of putting a primitive value into an analogous object, such as creating an <code>Integer</code> to hold an <code>int</code>
value. Unboxing is the process of retrieving the primitive value from such an object.</p>
<p>Since the original value is unchanged during boxing and unboxing, there's no point in doing either when not needed. This also applies to autoboxing
and auto-unboxing (when Java implicitly handles the primitive/object transition for you).</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void examineInt(int a) {
  //...
}

public void examineInteger(Integer a) {
  // ...
}

public void func() {
  int i = 0;
  Integer iger1 = Integer.valueOf(0);
  double d = 1.0;

  int dIntValue = new Double(d).intValue(); // Noncompliant

  examineInt(new Integer(i).intValue()); // Noncompliant; explicit box/unbox
  examineInt(Integer.valueOf(i));  // Noncompliant; boxed int will be auto-unboxed

  examineInteger(i); // Compliant; value is boxed but not then unboxed
  examineInteger(iger1.intValue()); // Noncompliant; unboxed int will be autoboxed
}
</pre>ZBUG
ù
squid:S2274ç
squidS2274T"Object.wait(...)" and "Condition.await(...)" should be called inside a "while" loop"MINOR*java:î<p>According to the documentation of the Java <code>Condition</code> interface:</p>
<blockquote>
  <p>When waiting upon a <code>Condition</code>, a "spurious wakeup" is permitted to occur, in general, as a concession to the underlying platform
  semantics. This has little practical impact on most application programs as a Condition should always be waited upon in a loop, testing the state
  predicate that is being waited for. An implementation is free to remove the possibility of spurious wakeups but it is recommended that applications
  programmers always assume that they can occur and so always wait in a loop.</p>
</blockquote>
<p>The same advice is also found for the <code>Object.wait(...)</code> method:</p>
<blockquote>
  <p>waits should always occur in loops, like this one:</p>
  <pre>
synchronized (obj) {
  while (&lt;condition does not hold&gt;){
    obj.wait(timeout);
  }
   ... // Perform action appropriate to condition
}
</pre>
</blockquote>
<h2>Noncompliant Code Example</h2>
<pre>
synchronized (obj) {
  if (!suitableCondition()){
    obj.wait(timeout);   //the thread can wakeup whereas the condition is still false
  }
   ... // Perform action appropriate to condition
}
</pre>
<h2>Compliant Solution</h2>
<pre>
synchronized (obj) {
  while (!suitableCondition()){
    obj.wait(timeout);
  }
   ... // Perform action appropriate to condition
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9QIhAQ">CERT THI03-J.</a> - Always invoke wait() and await() methods inside a loop
  </li>
</ul>ZBUG
—
squid:S1065¡
squidS1065Unused labels should be removed"MAJOR*java:ˆ<p>If a label is declared but not used in the program, it can be considered as dead code and should therefore be removed.</p>
<p>This will improve maintainability as developers will not wonder what this label is used for.</p>
<h2>Noncompliant Code Example</h2>
<pre>
void foo() {
  outer: //label is not used.
  for(int i = 0; i&lt;10; i++) {
    break;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
void foo() {
  for(int i = 0; i&lt;10; i++) {
    break;
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2012, 2.6 - A function should not contain unused label declarations </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>Z
CODE_SMELL
Ò	
squid:S1186·	
squidS1186Methods should not be empty"CRITICAL*java:ó	<p>There are several reasons for a method not to have a method body:</p>
<ul>
  <li> It is an unintentional omission, and should be fixed to prevent an unexpected behavior in production. </li>
  <li> It is not yet, or never will be, supported. In this case an <code>UnsupportedOperationException</code> should be thrown. </li>
  <li> The method is an intentionally-blank override. In this case a nested comment should explain the reason for the blank override. </li>
  <li> There is a desire to provide a public, no-args constructor. In this case, it can simply be omitted from the code; a default constructor will
  automatically be generated. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething() {
}

public void doSomethingElse() {
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@Override
public void doSomething() {
  // Do nothing because of X and Y.
}

@Override
public void doSomethingElse() {
  throw new UnsupportedOperationException();
}
</pre>
<h2>Exceptions</h2>
<p>An abstract class may have empty methods, in order to provide default implementations for child classes.</p>
<pre>
public abstract class Animal {
  void speak() {
  }
}
</pre>Z
CODE_SMELL
Ä
squid:S2154
squidS2154cDissimilar primitive wrappers should not be used with the ternary operator without explicit casting"MAJOR*java:Ë<p>If wrapped primitive values (e.g. <code>Integers</code> and <code>Floats</code>) are used in a ternary operator (e.g. <code>a?b:c</code>), both
values will be unboxed and coerced to a common type, potentially leading to unexpected results. To avoid this, add an explicit cast to a compatible
type.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Integer i = 123456789;
Float f = 1.0f;
Number n = condition ? i : f;  // Noncompliant; i is coerced to float. n = 1.23456792E8
</pre>
<h2>Compliant Solution</h2>
<pre>
Integer i = 123456789;
Float f = 1.0f;
Number n = condition ? (Number) i : f;  // n = 123456789
</pre>ZBUG
≈ 
squid:S2275µ 
squidS2275MPrintf-style format strings should not lead to unexpected behavior at runtime"MAJOR*java:√<p>Because <code>printf</code>-style format strings are interpreted at runtime, rather than validated by the Java compiler, they can contain errors
that lead to unexpected behavior or runtime errors. This rule statically validates the good behavior of <code>printf</code>-style formats when calling
the <code>format(...)</code> methods of <code>java.util.Formatter</code>, <code>java.lang.String</code>, <code>java.io.PrintStream</code>,
<code>MessageFormat</code>, and <code>java.io.PrintWriter</code> classes and the <code>printf(...)</code> methods of <code>java.io.PrintStream</code>
or <code>java.io.PrintWriter</code> classes. </p>
<h2>Noncompliant Code Example</h2>
<pre>
String.format("The value of my integer is %d", "Hello World");  // Noncompliant; an 'int' is expected rather than a String
String.format("First {0} and then {1}", "foo", "bar");  //Noncompliant. Looks like there is a confusion with the use of {{java.text.MessageFormat}}, parameters "foo" and "bar" will be simply ignored here
String.format("Duke's Birthday year is %tX", c);  //Noncompliant; X is not a supported time conversion character
String.format("Display %3$d and then %d", 1, 2, 3);   //Noncompliant; the second argument '2' is unused
String.format("Display %0$d and then %d", 1);   //Noncompliant; arguments are numbered starting from 1
String.format("Too many arguments %d and %d", 1, 2, 3);  //Noncompliant; the third argument '3' is unused
String.format("Not enough arguments %d and %d", 1);  //Noncompliant; the second argument is missing
String.format("First Line\n");   //Noncompliant; %n should be used in place of \n to produce the platform-specific line separator
String.format("%&lt; is equals to %d", 2);   //Noncompliant; the argument index '&lt;' refers to the previous format specifier but there isn't one
String.format("Is myObject null ? %b", myObject);   //Noncompliant; when a non-boolean argument is formatted with %b, it prints true for any nonnull value, and false for null. Even if intended, this is misleading. It's better to directly inject the boolean value (myObject == null in this case)
String.format("value is " + value); // Noncompliant
String s = String.format("string without arguments"); // Noncompliant

MessageFormat.format("Result {1}.", value); // Noncompliant; Not enough arguments. (first element is {0})
MessageFormat.format("Result '{0}'.", value); // Noncompliant; String contains no format specifiers. (quote are discarding format specifiers)
MessageFormat.format("Result {{0}.", value); // Noncompliant; Unbalanced number of curly brace (single curly braces should be escaped)
MessageFormat.format("Result ' {0}", value); // Noncompliant; Unbalanced number of quotes (single quote must be escaped)
MessageFormat.format("Result {0}.", value, value);  // Noncompliant; 2nd argument is not used
MessageFormat.format("Result {0}.", myObject.toString()); // Noncompliant; no need to call toString() on objects
</pre>
<h2>Compliant Solution</h2>
<pre>
String.format("The value of my integer is %d", 3);
String.format("First %s and then %s", "foo", "bar");
String.format("Duke's Birthday year is %tY", c);
String.format("Display %2$d and then %d", 1, 3);
String.format("Display %1$d and then %d", 1);
String.format("Too many arguments %d %d", 1, 2);
String.format("Not enough arguments %d and %d", 1, 2);
String.format("First Line%n");
String.format("%d is equals to %&lt;", 2);
String.format("Is myObject null ? %b", myObject == null);
String.format("value is %d", value);
String s = "string without arguments";

MessageFormat.format("Result {0}.", value);
MessageFormat.format("Result '{0}'  =  {0}", value);
MessageFormat.format("Result {0} &amp; {1}.", value, value);
MessageFormat.format("Result {0}.", myObject);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/wQA1">CERT, FIO47-C.</a> - Use valid format strings </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/e4EyAQ">CERT, FIO00-CPP.</a> - Take care when creating format strings </li>
</ul>ZBUG
ü
squid:S1185è
squidS1185UOverriding methods should do more than simply call the same method in the super class"MINOR*java:é<p>Overriding a method just to call the same method from the super class without performing any other actions is useless and misleading. The only time
this is justified is in <code>final</code> overriding methods, where the effect is to lock in the parent class behavior. This rule ignores such
overrides of <code>equals</code>, <code>hashCode</code> and <code>toString</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething() {
  super.doSomething();
}

@Override
public boolean isLegal(Action action) {
  return super.isLegal(action);
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@Override
public boolean isLegal(Action action) {         // Compliant - not simply forwarding the call
  return super.isLegal(new Action(/* ... */));
}

@Id
@Override
public int getId() {                            // Compliant - there is annotation different from @Override
  return super.getId();
}
</pre>Z
CODE_SMELL
ô
squid:UndocumentedApiˇ
squidUndocumentedApiHPublic types, methods and fields (API) should be documented with Javadoc"MAJOR*java2S1176:˙<p>Try to imagine using the standard Java API (Collections, JDBC, IO, ...) without Javadoc. It would be a nightmare, because Javadoc is the only way
to understand of the contract of the API. Documenting an API with Javadoc increases the productivity of the developers consuming it.</p>
<p>The following Javadoc elements are required:</p>
<ul>
  <li> Parameters, using <code>@param parameterName</code>. </li>
  <li> Method return values, using <code>@return</code>. </li>
  <li> Generic types, using <code>@param &lt;T&gt;</code>. </li>
</ul>
<p>The following public methods and constructors are not taken into account by this rule:</p>
<ul>
  <li> Getters and setters. </li>
  <li> Methods with @Override annotation. </li>
  <li> Empty constructors. </li>
  <li> Static constants. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
/**
  * This is a Javadoc comment
  */
public class MyClass&lt;T&gt; implements Runnable {    // Noncompliant - missing '@param &lt;T&gt;'

  public static final DEFAULT_STATUS = 0;    // Compliant - static constant
  private int status;                           // Compliant - not public

  public String message;                  // Noncompliant

  public MyClass() {                         // Noncompliant - missing documentation
    this.status = DEFAULT_STATUS;
  }

  public void setStatus(int status) {  // Compliant - setter
    this.status = status;
  }

  @Override
  public void run() {                          // Compliant - has @Override annotation
  }

  protected void doSomething() {    // Compliant - not public
  }

  public void doSomething2(int value) {  // Noncompliant
  }

  public int doSomething3(int value) {  // Noncompliant
    return value;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
/**
  * This is a Javadoc comment
  * @param &lt;T&gt; ...
  */
public class MyClass&lt;T&gt; implements Runnable {

  public static final DEFAULT_STATUS = 0;
  private int status;

  /**
    * This is a Javadoc comment
    */
  public String message;

  /**
   * Class comment...
   */
  public MyClass() {
    this.status = DEFAULT_STATUS;
  }

  public void setStatus(int status) {
    this.status = status;
  }

  @Override
  public void run() {
  }

  protected void doSomething() {
  }

  /**
    * @param value ...
    */
  public void doSomething(int value) {

  /**
    *  {@inheritDoc}
    */
  public int doSomething(int value) {
    return value;
  }
}
</pre>Z
CODE_SMELL
π
squid:S3008©
squidS3008CStatic non-final field names should comply with a naming convention"MINOR*java:∫<p>Shared naming conventions allow teams to collaborate efficiently. This rule checks that static non-final field names match a provided regular
expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default regular expression <code>^[a-z][a-zA-Z0-9]*$</code>:</p>
<pre>
public final class MyClass {
   private static String foo_bar;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {
   private static String fooBar;
}
</pre>Z
CODE_SMELL
Ô	
squid:S2151ﬂ	
squidS2151*"runFinalizersOnExit" should not be called"CRITICAL*java:ç	<p>Running finalizers on JVM exit is disabled by default. It can be enabled with <code>System.runFinalizersOnExit</code> and
<code>Runtime.runFinalizersOnExit</code>, but both methods are deprecated because they are are inherently unsafe. </p>
<p>According to the Oracle Javadoc:</p>
<blockquote>
  <p>It may result in finalizers being called on live objects while other threads are concurrently manipulating those objects, resulting in erratic
  behavior or deadlock.</p>
</blockquote>
<p>If you really want to be execute something when the virtual machine begins its shutdown sequence, you should attach a shutdown hook. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public static void main(String [] args) {
  ...
  System.runFinalizersOnExit(true);  // Noncompliant
  ...
}

protected void finalize(){
  doSomething();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public static void main(String [] args) {
  Runtime.addShutdownHook(new Runnable() {
    public void run(){
      doSomething();
    }
  });
  //...
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/H4cbAQ">CERT, MET12-J.</a> - Do not use finalizers </li>
</ul>ZBUG
«
squid:S2272∑
squidS2272?"Iterator.next()" methods should throw "NoSuchElementException""MINOR*java:”<p>By contract, any implementation of the <code>java.util.Iterator.next()</code> method should throw a <code>NoSuchElementException</code> exception
when the iteration has no more elements. Any other behavior when the iteration is done could lead to unexpected behavior for users of this
<code>Iterator</code>. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyIterator implements Iterator&lt;String&gt;{
  ...
  public String next(){
    if(!hasNext()){
      return null;
    }
    ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyIterator implements Iterator&lt;String&gt;{
  ...
  public String next(){
    if(!hasNext()){
      throw new NoSuchElementException();
    }
    ...
  }
}
</pre>ZBUG
ƒ	
squid:S2273¥	
squidS2273r"wait(...)", "notify()" and "notifyAll()" methods should only be called when a lock is obviously held on an object"MAJOR*java:ù<p>By contract, the method <code>Object.wait(...)</code>, <code>Object.notify()</code> and <code>Object.notifyAll()</code> should be called by a
thread that is the owner of the object's monitor. If this is not the case an <code>IllegalMonitorStateException</code> exception is thrown. This rule
reinforces this constraint by making it mandatory to call one of these methods only inside a <code>synchronized</code> method or statement. </p>
<h2>Noncompliant Code Example</h2>
<pre>
private void removeElement() {
  while (!suitableCondition()){
    obj.wait();
  }
  ... // Perform removal
}
</pre>
<p>or</p>
<pre>
private void removeElement() {
  while (!suitableCondition()){
    wait();
  }
  ... // Perform removal
}
</pre>
<h2>Compliant Solution</h2>
<pre>
private void removeElement() {
  synchronized(obj) {
    while (!suitableCondition()){
      obj.wait();
    }
    ... // Perform removal
  }
}
</pre>
<p>or</p>
<pre>
private synchronized void removeElement() {
  while (!suitableCondition()){
    wait();
  }
  ... // Perform removal
}
</pre>ZBUG
¸
squid:S2391Ï
squidS23913JUnit framework methods should be declared properly"BLOCKER*java:ã<p>If the <code>suite</code> method in a JUnit 3 <code>TestCase</code> is not declared correctly, it will not be used. Such a method must be named
"suite", have no arguments, be <code>public static</code>, and must return either a <code>junit.framework.Test</code> or a
<code>junit.framework.TestSuite</code>.</p>
<p>Similarly, <code>setUp</code> and <code>tearDown</code> methods that aren't properly capitalized will also be ignored.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Test suite() { ... }  // Noncompliant; must be public static
public static boolean suite() { ... }  // Noncompliant; wrong return type
public static Test suit() { ... }  // Noncompliant; typo in method name
public static Test suite(int count) { ... } // Noncompliant; must be no-arg

public void setup() { ... } // Noncompliant; should be setUp
public void tearDwon() { ... }  // Noncompliant; should be tearDown
</pre>
<h2>Compliant Solution</h2>
<pre>
public static Test suite() { ... }
public void setUp() { ... }
public void tearDown() { ... }
</pre>Z
CODE_SMELL
Õ
squid:S1182Ω
squidS1182LClasses that override "clone" should be "Cloneable" and call "super.clone()""MINOR*java:Ã<p><code>Cloneable</code> is the marker <code>Interface</code> that indicates that <code>clone()</code> may be called on an object. Overriding
<code>clone()</code> without implementing <code>Cloneable</code> can be useful if you want to control how subclasses clone themselves, but otherwise,
it's probably a mistake.</p>
<p>The usual convention for <code>Object.clone()</code> according to Oracle's Javadoc is:</p>
<ol>
  <li> <code>x.clone() != x</code> </li>
  <li> <code>x.clone().getClass() == x.getClass()</code> </li>
  <li> <code>x.clone().equals\(x\)</code> </li>
</ol>
<p>Obtaining the object that will be returned by calling <code>super.clone()</code> helps to satisfy those invariants:</p>
<ol>
  <li> <code>super.clone()</code> returns a new object instance </li>
  <li> <code>super.clone()</code> returns an object of the same type as the one <code>clone()</code> was called on </li>
  <li> <code>Object.clone()</code> performs a shallow copy of the object's state </li>
</ol>
<h2>Noncompliant Code Example</h2>
<pre>
class BaseClass {  // Noncompliant; should implement Cloneable
  @Override
  public Object clone() throws CloneNotSupportedException {    // Noncompliant; should return the super.clone() instance
    return new BaseClass();
  }
}

class DerivedClass extends BaseClass implements Cloneable {
  /* Does not override clone() */

  public void sayHello() {
    System.out.println("Hello, world!");
  }
}

class Application {
  public static void main(String[] args) throws Exception {
    DerivedClass instance = new DerivedClass();
    ((DerivedClass) instance.clone()).sayHello();              // Throws a ClassCastException because invariant #2 is violated
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class BaseClass implements Cloneable {
  @Override
  public Object clone() throws CloneNotSupportedException {    // Compliant
    return super.clone();
  }
}

class DerivedClass extends BaseClass implements Cloneable {
  /* Does not override clone() */

  public void sayHello() {
    System.out.println("Hello, world!");
  }
}

class Application {
  public static void main(String[] args) throws Exception {
    DerivedClass instance = new DerivedClass();
    ((DerivedClass) instance.clone()).sayHello();              // Displays "Hello, world!" as expected. Invariant #2 is satisfied
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/580.html">MITRE, CWE-580</a> - clone() Method Without super.clone() </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/CQHEAw">CERT, MET53-J.</a> - Ensure that the clone() method calls super.clone() </li>
</ul>ZBUG
‘
squid:S1181ƒ
squidS1181(Throwable and Error should not be caught"MAJOR*java:˜<p><code>Throwable</code> is the superclass of all errors and exceptions in Java.</p>
<p><code>Error</code> is the superclass of all errors, which are not meant to be caught by applications.</p>
<p>Catching either <code>Throwable</code> or <code>Error</code> will also catch <code>OutOfMemoryError</code> and <code>InternalError</code>, from
which an application should not attempt to recover.</p>
<h2>Noncompliant Code Example</h2>
<pre>
try { /* ... */ } catch (Throwable t) { /* ... */ }
try { /* ... */ } catch (Error e) { /* ... */ }
</pre>
<h2>Compliant Solution</h2>
<pre>
try { /* ... */ } catch (RuntimeException e) { /* ... */ }
try { /* ... */ } catch (MyException e) { /* ... */ }
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/396.html">MITRE, CWE-396</a> - Declaration of Catch for Generic Exception </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/BIB3AQ">CERT, ERR08-J.</a> - Do not catch NullPointerException or any of its ancestors
  </li>
</ul>ZBUG
î
squid:S3578Ñ
squidS35783Test methods should comply with a naming convention"MINOR*java:•<p>Shared naming conventions allow teams to collaborate efficiently. This rule raises an issue when a test method name does not match the provided
regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default value: <code>^test[A-Z][a-zA-Z0-9]*$</code></p>
<pre>
@Test
public void foo() {  // Noncompliant
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@Test
public void testFoo() {
  // ...
}
</pre>Z
CODE_SMELL
Ω
squid:S2127≠
squidS21276"Double.longBitsToDouble" should not be used for "int""MAJOR*java:“<p><code>Double.longBitsToDouble</code> expects a 64-bit, <code>long</code> argument. Pass it a smaller value, such as an <code>int</code> and the
mathematical conversion into a <code>double</code> simply won't work as anticipated because the layout of the bits will be interpreted incorrectly, as
if a child were trying to use an adult's gloves.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int i = 42;
double d = Double.longBitsToDouble(i);  // Noncompliant
</pre>ZBUG
Â
squid:S1158’
squidS1158VPrimitive wrappers should not be instantiated only for "toString" or "compareTo" calls"MINOR*java:⁄<p>Creating temporary primitive wrapper objects only for <code>String</code> conversion or the use of the <code>compareTo</code> method is
inefficient.</p>
<p>Instead, the static <code>toString()</code> or <code>compare</code> method of the primitive wrapper class should be used.</p>
<h2>Noncompliant Code Example</h2>
<pre>
new Integer(myInteger).toString();  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
Integer.toString(myInteger);        // Compliant
</pre>ZBUG
ÿ
squid:S2245»
squidS2245LPseudorandom number generators (PRNGs) should not be used in secure contexts"CRITICAL*java: <p>When software generates predictable values in a context requiring unpredictability, it may be possible for an attacker to guess the next value that
will be generated, and use this guess to impersonate another user or access sensitive information.</p>
<p>As the <code>java.util.Random</code> class relies on a pseudorandom number generator, this class and relating <code>java.lang.Math.random()</code>
method should not be used for security-critical applications or for protecting sensitive data. In such context, the
<code>java.security.SecureRandom</code> class which relies on a cryptographically strong random number generator (RNG) should be used in place.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Random random = new Random();
byte bytes[] = new byte[20];
random.nextBytes(bytes);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/338.html">MITRE, CWE-338</a> - Use of Cryptographically Weak Pseudo-Random Number Generator
  (PRNG) </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/330.html">MITRE, CWE-330</a> - Use of Insufficiently Random Values </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/326.html">MITRE, CWE-326</a> - Inadequate Encryption Strength </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/310">MITRE, CWE-310</a> - Cryptographic Issues </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/mAFqAQ">CERT, MSC02-J.</a> - Generate strong random numbers </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/qw4">CERT, MSC30-C.</a> - Do not use the rand() function for generating pseudorandom
  numbers </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/WYIyAQ">CERT, MSC50-CPP.</a> - Do not use std::rand() for generating pseudorandom
  numbers </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#PREDICTABLE_RANDOM">Predictable Pseudo Random Number
  Generator</a> </li>
</ul>ZVULNERABILITY
Ó
squid:S1157ﬁ
squidS1157]Case insensitive string comparisons should be made without intermediate upper or lower casing"MINOR*java:‹<p>Using <code>toLowerCase()</code> or <code>toUpperCase()</code> to make case insensitive comparisons is inefficient because it requires the creation
of temporary, intermediate <code>String</code> objects.</p>
<h2>Noncompliant Code Example</h2>
<pre>
boolean result1 = foo.toUpperCase().equals(bar);             // Noncompliant
boolean result2 = foo.equals(bar.toUpperCase());             // Noncompliant
boolean result3 = foo.toLowerCase().equals(bar.LowerCase()); // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
boolean result = foo.equalsIgnoreCase(bar);                  // Compliant
</pre>ZBUG
ì
squid:S3577É
squidS35773Test classes should comply with a naming convention"MINOR*java:§<p>Shared naming conventions allow teams to collaborate efficiently. This rule raises an issue when a test class name does not match the provided
regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default value: <code>^((Test|IT)[a-zA-Z0-9]+|[A-Z][a-zA-Z0-9]*(Test|IT|TestCase|ITCase))$</code></p>
<pre>
class Foo {  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class FooTest {
}
</pre>Z
CODE_SMELL
Ô
squid:S2122ﬂ
squidS2122<"ScheduledThreadPoolExecutor" should not have 0 core threads"CRITICAL*java:˚<p><code>java.util.concurrent.ScheduledThreadPoolExecutor</code>'s pool is sized with <code>corePoolSize</code>, so setting <code>corePoolSize</code>
to zero means the executor will have no threads and run nothing.</p>
<p>This rule detects instances where <code>corePoolSize</code> is set to zero, via either its setter or the object constructor.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void do(){

  ScheduledThreadPoolExecutor stpe1 = new ScheduledThreadPoolExecutor(0); // Noncompliant

  ScheduledThreadPoolExecutor stpe2 = new ScheduledThreadPoolExecutor(POOL_SIZE);
  stpe2.setCorePoolSize(0);  // Noncompliant
</pre>ZBUG
‚
 squid:LabelsShouldNotBeUsedCheckΩ
squidLabelsShouldNotBeUsedCheckLabels should not be used"MAJOR*java2S1119:‹<p>Labels are not commonly used in Java, and many developers do not understand how they work. Moreover, their usage makes the control flow harder to
follow, which reduces the code's readability.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int matrix[][] = {
  {1, 2, 3},
  {4, 5, 6},
  {7, 8, 9}
};

outer: for (int row = 0; row &lt; matrix.length; row++) {   // Non-Compliant
  for (int col = 0; col &lt; matrix[row].length; col++) {
    if (col == row) {
      continue outer;
    }
    System.out.println(matrix[row][col]);                // Prints the elements under the diagonal, i.e. 4, 7 and 8
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
for (int row = 1; row &lt; matrix.length; row++) {          // Compliant
  for (int col = 0; col &lt; row; col++) {
    System.out.println(matrix[row][col]);                // Also prints 4, 7 and 8
  }
}
</pre>Z
CODE_SMELL
Ç
squid:S2123Ú
squidS2123*Values should not be uselessly incremented"MAJOR*java:£<p>A value that is incremented or decremented and then not stored is at best wasted code and at worst a bug.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int pickNumber() {
  int i = 0;
  int j = 0;

  i = i++; // Noncompliant; i is still zero

  return j++; // Noncompliant; 0 returned
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public int pickNumber() {
  int i = 0;
  int j = 0;

  i++;
  return ++j;
}
</pre>ZBUG
ﬂ
squid:S1153œ
squidS11533String.valueOf() should not be appended to a String"MINOR*java:<p>Appending <code>String.valueOf()</code> to a <code>String</code> decreases the code readability.</p>
<p>The argument passed to <code>String.valueOf()</code> should be directly appended instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void display(int i){
  System.out.println("Output is " + String.valueOf(i));    // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void display(int i){
  System.out.println("Output is " + i);                    // Compliant
}
</pre>Z
CODE_SMELL
ﬂ
squid:S2129œ
squidS2129UConstructors should not be used to instantiate "String" and primitive-wrapper classes"MINOR*java:’<p>Constructors for <code>Strings</code> and the objects used to wrap primitives should never be used. Doing so is less clear and uses more memory
than simply using the desired value in the case of strings, and using <code>valueOf</code> for everything else.</p>
<p>Further, these constructors are deprecated in Java 9, which is an indication that they will eventually be removed from the language altogether.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String empty = new String(); // Noncompliant; yields essentially "", so just use that.
String nonempty = new String("Hello world"); // Noncompliant
Double myDouble = new Double(1.1); // Noncompliant; use valueOf
Integer integer = new Integer(1); // Noncompliant
Boolean bool = new Boolean(true); // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
String empty = "";
String nonempty = "Hello world";
Double myDouble = Double.valueOf(1.1);
Integer integer = Integer.valueOf(1);
Boolean bool = Boolean.valueOf(true);
</pre>ZBUG
’
squid:S1151≈
squidS1151<"switch case" clauses should not have too many lines of code"MAJOR*java:›<p>The <code>switch</code> statement should be used only to clearly define some new branches in the control flow. As soon as a <code>case</code>
clause contains too many statements this highly decreases the readability of the overall control flow statement. In such case, the content of the
<code>case</code> clause should be extracted into a dedicated method.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold of 5:</p>
<pre>
switch (myVariable) {
  case 0: // 6 lines till next case
    methodCall1("");
    methodCall2("");
    methodCall3("");
    methodCall4("");
    break;
  case 1:
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
switch (myVariable) {
  case 0:
    doSomething()
    break;
  case 1:
  ...
}
...
private void doSomething(){
    methodCall1("");
    methodCall2("");
    methodCall3("");
    methodCall4("");
}
</pre>Z
CODE_SMELL
ß
squid:S1150ó
squidS1150%Enumeration should not be implemented"MAJOR*java:∆<p>From the official Oracle Javadoc:</p>
<blockquote>
  <p>NOTE: The functionality of this Enumeration interface is duplicated by the Iterator interface. In addition, Iterator adds an optional remove
  operation, and has shorter method names. New implementations should consider using Iterator in preference to Enumeration.</p>
</blockquote>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass implements Enumeration {  // Non-Compliant
  /* ... */
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass implements Iterator {     // Compliant
  /* ... */
}
</pre>Z
CODE_SMELL
Â
squid:S00100‘
squidS001003Method names should comply with a naming convention"MINOR*java2S100:Ó<p>Shared naming conventions allow teams to collaborate efficiently. This rule checks that all method names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With default provided regular expression <code>^[a-z][a-zA-Z0-9]*$</code>:</p>
<pre>
public int DoSomething(){...}
</pre>
<h2>Compliant Solution</h2>
<pre>
public int doSomething(){...}
</pre>
<h2>Exceptions</h2>
<p>Overriding methods are excluded. </p>
<pre>
@Override
public int Do_Something(){...}
</pre>Z
CODE_SMELL
é
squid:S00101˝
squidS001012Class names should comply with a naming convention"MINOR*java2S101:ò<p>Sharing some naming conventions is a key point to make it possible for a team to efficiently collaborate. This rule allows to check that all class
names match a provided regular expression.</p>
<h2>Noncompliant Code Example</h2>
<p>With default provided regular expression <code>^[A-Z][a-zA-Z0-9]*$</code>:</p>
<pre>
class my_class {...}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {...}
</pre>Z
CODE_SMELL
‡

squid:S923—
squidS923CFunctions should not be defined with a variable number of arguments"INFO*java:‰<p>As stated per effective java : </p>
<blockquote>
  <p>Varargs methods are a convenient way to define methods that require a variable number of arguments, but they should not be overused. They can
  produce confusing results if used inappropriately.</p>
</blockquote>
<h2>Noncompliant Code Example</h2>
<pre>
void fun ( String... strings )	// Noncompliant
{
  // ...
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 16.1 - Functions shall not be defined with a variable number of arguments. </li>
  <li> MISRA C++:2008, 8-4-1 - Functions shall not be defined using the ellipsis notation. </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/i4CW">CERT, DCL50-CPP.</a> - Do not define a C-style variadic function </li>
</ul>Z
CODE_SMELL
«
squid:S2258∑
squidS2258L"javax.crypto.NullCipher" should not be used for anything other than testing"BLOCKER*java:∫<p>By contract, the <code>NullCipher</code> class provides an "identity cipher" <del></del> one that does not transform or encrypt the plaintext in
any way. As a consequence, the ciphertext is identical to the plaintext. So this class should be used for testing, and never in production code.</p>
<h2>Noncompliant Code Example</h2>
<pre>
NullCipher nc=new NullCipher();
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/327.html">CWE-327</a>: Use of a Broken or Risky Cryptographic Algorithm </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#NULL_CIPHER">NullCipher Unsafe</a> </li>
</ul>ZVULNERABILITY
ë
squid:S2259Å
squidS2259(Null pointers should not be dereferenced"MAJOR*java:¥<p>A reference to <code>null</code> should never be dereferenced/accessed. Doing so will cause a <code>NullPointerException</code> to be thrown. At
best, such an exception will cause abrupt program termination. At worst, it could expose debugging information that would be useful to an attacker, or
it could allow an attacker to bypass security measures.</p>
<p>Note that when they are present, this rule takes advantage of <code>@CheckForNull</code> and <code>@Nonnull</code> annotations defined in <a
href="https://jcp.org/en/jsr/detail?id=305">JSR-305</a> to understand which values are and are not nullable.</p>
<p><code>@Nullable</code> denotes that, under some unspecified circumstances, the value might be null. To keep false positives low, this annotation is
ignored. Whether an explicit test is required or not is left to the developer's discretion.</p>
<h2>Noncompliant Code Example</h2>
<p>Here are some examples of null pointer dereferences detected by this rule:</p>
<pre>
@CheckForNull
String getName(){...}

public boolean isNameEmpty() {
  return getName().length() == 0; // Noncompliant; the result of getName() could be null, but isn't null-checked
}
</pre>
<pre>
Connection conn = null;
Statement stmt = null;
try{
  conn = DriverManager.getConnection(DB_URL,USER,PASS);
  stmt = conn.createStatement();
  // ...

}catch(Exception e){
  e.printStackTrace();
}finally{
  stmt.close();   // Noncompliant; stmt could be null if an exception was thrown in the try{} block
  conn.close();  // Noncompliant; conn could be null if an exception was thrown
}
</pre>
<pre>
private void merge(@Nonnull Color firstColor, @Nonnull Color secondColor){...}

public  void append(@CheckForNull Color color) {
    merge(currentColor, color);  // Noncompliant; color should be null-checked because merge(...) doesn't accept nullable parameters
}
</pre>
<pre>
void paint(Color color) {
  if(color == null) {
    System.out.println("Unable to apply color " + color.toString());  // Noncompliant; NullPointerException will be thrown
    return;
  }
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/476.html">MITRE, CWE-476</a> - NULL Pointer Dereference </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/PAw">CERT, EXP34-C.</a> - Do not dereference null pointers </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/ZwDOAQ">CERT, EXP01-J.</a> - Do not use a null in a case where an object is required
  </li>
</ul>ZBUG
º
squid:S1168¨
squidS1168?Empty arrays and collections should be returned instead of null"MAJOR*java:¡<p>Returning <code>null</code> instead of an actual array or collection forces callers of the method to explicitly test for nullity, making them more
complex and less readable.</p>
<p>Moreover, in many cases, <code>null</code> is used as a synonym for empty.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public static List&lt;Result&gt; getResults() {
  return null;                             // Noncompliant
}

public static Result[] getResults() {
  return null;                             // Noncompliant
}

public static void main(String[] args) {
  Result[] results = getResults();

  if (results != null) {                   // Nullity test required to prevent NPE
    for (Result result: results) {
      /* ... */
    }
  }
}

</pre>
<h2>Compliant Solution</h2>
<pre>
public static List&lt;Result&gt; getResults() {
  return Collections.emptyList();          // Compliant
}

public static Result[] getResults() {
  return new Result[0];
}

public static void main(String[] args) {
  for (Result result: getResults()) {
    /* ... */
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/AgG7AQ">CERT, MSC19-C.</a> - For functions that return an array, prefer returning an
  empty array over a null value </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/zwHEAw">CERT, MET55-J.</a> - Return an empty array or collection instead of a null
  value for methods that return an array or collection </li>
</ul>Z
CODE_SMELL
í	
squid:S2257Ç	
squidS22575Only standard cryptographic algorithms should be used"CRITICAL*java:õ<p>The use of a non-standard algorithm is dangerous because a determined attacker may be able to break the algorithm and compromise whatever data has
been protected. Standard algorithms like <code>SHA-256</code>, <code>SHA-384</code>, <code>SHA-512</code>, ... should be used instead.</p>
<p>This rule tracks creation of <code>java.security.MessageDigest</code> subclasses.</p>
<h2>Noncompliant Code Example</h2>
<pre>
MyCryptographicAlgorithm extends MessageDigest {
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/327.html">CWE-327</a> - Use of a Broken or Risky Cryptographic Algorithm </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Porous Defenses </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#CUSTOM_MESSAGE_DIGEST">MessageDigest is Custom</a>
  </li>
</ul>ZVULNERABILITY
◊
squid:S2133«
squidS21330Objects should not be created only to "getClass""MINOR*java:Ú<p>Creating an object for the sole purpose of calling <code>getClass</code> on it is a waste of memory and cycles. Instead, simply use the class'
<code>.class</code> property.</p>
<h2>Noncompliant Code Example</h2>
<pre>
MyObject myOb = new MyObject();  // Noncompliant
Class c = myOb.getClass();
</pre>
<h2>Compliant Solution</h2>
<pre>
Class c = MyObject.class;
</pre>ZBUG
º
squid:S2254¨
squidS2254?"HttpServletRequest.getRequestedSessionId()" should not be used"CRITICAL*java:ª<p>According to the Oracle Java API, the <code>HttpServletRequest.getRequestedSessionId()</code> method:</p>
<blockquote>
  <p>Returns the session ID specified by the client. This may not be the same as the ID of the current valid session for this request. If the client
  did not specify a session ID, this method returns null.</p>
</blockquote>
<p>The session ID it returns is either transmitted in a cookie or a URL parameter so by definition, nothing prevents the end-user from manually
updating the value of this session ID in the HTTP request. </p>
<p>Here is an example of a updated HTTP header:</p>
<pre>
GET /pageSomeWhere HTTP/1.1
Host: webSite.com
User-Agent: Mozilla/5.0
Cookie: JSESSIONID=Hacked_Session_Value'''"&gt;
</pre>
<p>Due to the ability of the end-user to manually change the value, the session ID in the request should only be used by a servlet container (E.G.
Tomcat or Jetty) to see if the value matches the ID of an an existing session. If it does not, the user should be considered unauthenticated.
Moreover, this session ID should never be logged to prevent hijacking of active sessions.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if(isActiveSession(request.getRequestedSessionId()) ){
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/807">MITRE, CWE-807</a> - Reliance on Untrusted Inputs in a Security Decision </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Porous Defenses </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management">OWASP Top Ten 2013 Category A2</a> -
  Broken Authentication and Session Management </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#SERVLET_SESSION_ID">Untrusted Session Cookie Value</a>
  </li>
</ul>ZVULNERABILITY
˙
squid:S1166Í
squidS1166:Exception handlers should preserve the original exceptions"MAJOR*java:ã<p>When handling a caught exception, the original exception's message and stack trace should be logged or passed forward.</p>
<h2>Noncompliant Code Example</h2>
<pre>
 // Noncompliant - exception is lost
try { /* ... */ } catch (Exception e) { LOGGER.info("context"); }

// Noncompliant - exception is lost (only message is preserved)
try { /* ... */ } catch (Exception e) { LOGGER.info(e.getMessage()); }

// Noncompliant - exception is lost
try { /* ... */ } catch (Exception e) { throw new RuntimeException("context"); }
</pre>
<h2>Compliant Solution</h2>
<pre>
try { /* ... */ } catch (Exception e) { LOGGER.info(e); }

try { /* ... */ } catch (Exception e) { throw new RuntimeException(e); }

try {
  /* ... */
} catch (RuntimeException e) {
  doSomething();
  throw e;
} catch (Exception e) {
  // Conversion into unchecked exception is also allowed
  throw new RuntimeException(e);
}
</pre>
<h2>Exceptions</h2>
<p><code>InterruptedException</code>, <code>NumberFormatException</code>, <code>DateTimeParseException</code>, <code>ParseException</code> and
<code>MalformedURLException</code> exceptions are arguably used to indicate nonexceptional outcomes. Similarly, handling
<code>NoSuchMethodException</code> is often required when dealing with the Java reflection API.</p>
<p>Because they are part of Java, developers have no choice but to deal with them. This rule does not verify that those particular exceptions are
correctly handled.</p>
<pre>
int myInteger;
try {
  myInteger = Integer.parseInt(myString);
} catch (NumberFormatException e) {
  // It is perfectly acceptable to not handle "e" here
  myInteger = 0;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/6gEqAQ">CERT, ERR00-J.</a> - Do not suppress or ignore checked exceptions </li>
</ul>ZBUG
©
squid:S2134ô
squidS2134CClasses extending java.lang.Thread should override the "run" method"MAJOR*java:±<p>According to the Java API documentation:</p>
<blockquote>
  <p>There are two ways to create a new thread of execution. One is to declare a class to be a subclass of Thread. This subclass should override the
  run method of class Thread. An instance of the subclass can then be allocated and started...</p>
  <p>The other way to create a thread is to declare a class that implements the Runnable interface. That class then implements the run method. An
  instance of the class can then be allocated, passed as an argument when creating Thread, and started.</p>
</blockquote>
<p>By definition, extending the Thread class without overriding the <code>run</code> method doesn't make sense, and implies that the contract of the
<code>Thread</code> class is not well understood.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyRunner extends Thread { // Noncompliant; run method not overridden

  public void doSometing() {...}
}
</pre>ZBUG
ü	
squid:S1165è	
squidS1165%Exception classes should be immutable"MINOR*java:æ<p>Exceptions are meant to represent the application's state at the point at which an error occurred.</p>
<p>Making all fields in an <code>Exception</code> class <code>final</code> ensures that this state:</p>
<ul>
  <li> Will be fully defined at the same time the <code>Exception</code> is instantiated. </li>
  <li> Won't be updated or corrupted by a questionable error handler. </li>
</ul>
<p>This will enable developers to quickly understand what went wrong.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyException extends Exception {

  private int status;                               // Noncompliant

  public MyException(String message) {
    super(message);
  }

  public int getStatus() {
    return status;
  }

  public void setStatus(int status) {
    this.status = status;
  }

}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyException extends Exception {

  private final int status;

  public MyException(String message, int status) {
    super(message);
    this.status = status;
  }

  public int getStatus() {
    return status;
  }

}
</pre>Z
CODE_SMELL
Ç
squid:S2131Ú
squidS2131;Primitives should not be boxed just for "String" conversion"MINOR*java:í<p>"Boxing" is the process of putting a primitive value into a primitive-wrapper object. When that's done purely to use the wrapper class'
<code>toString</code> method, it's a waste of memory and cycles because those methods are <code>static</code>, and can therefore be used without a
class instance. Similarly, using the <code>static</code> method <code>valueOf</code> in the primitive-wrapper classes with a non-<code>String</code>
argument should be avoided, as should concatenating empty string <code>""</code> to a primitive.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int myInt = 4;
String myIntString = new Integer(myInt).toString(); // Noncompliant; creates &amp; discards an Integer object
myIntString = Integer.valueOf(myInt).toString(); // Noncompliant
myIntString = 4 + "";  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
int myInt = 4;
String myIntString = Integer.toString(myInt);
</pre>ZBUG
±
squid:S2252°
squidS2252,Loop conditions should be true at least once"MAJOR*java:–<p>If a <code>for</code> loop's condition is false before the first loop iteration, the loop will never be executed. Such loops are almost always
bugs, particularly when the initial value and stop conditions are hard-coded.</p>
<h2>Noncompliant Code Example</h2>
<pre>
for (int i = 10; i &lt; 10; i++) {  // Noncompliant
  // ...
</pre>ZBUG
´
squid:S2253õ
squidS2253 Track uses of disallowed methods"MAJOR*java:Õ<p>This rule allows banning certain methods.</p>
<h2>Noncompliant Code Example</h2>
<p>Given parameters:</p>
<ul>
  <li> className:java.lang.String </li>
  <li> methodName: replace </li>
  <li> argumentTypes: java.lang.CharSequence, java.lang.CharSequence </li>
</ul>
<pre>
String name;
name.replace("A","a");  // Noncompliant
</pre>@Z
CODE_SMELL
Ò
squid:S1163·
squidS11631Exceptions should not be thrown in finally blocks"MAJOR*java:ã<p>Throwing an exception from within a finally block will mask any exception which was previously thrown in the <code>try</code> or <code>catch</code>
block.</p>
<p>The masked's exception message and stack trace will be lost.</p>
<h2>Noncompliant Code Example</h2>
<pre>
try {
  /* some work which end up throwing an exception */
  throw new IllegalArgumentException();
} finally {
  /* clean up */
  throw new RuntimeException();       // Noncompliant; will mask the IllegalArgumentException
}
</pre>
<h2>Compliant Solution</h2>
<pre>
try {
  /* some work which end up throwing an exception */
  throw new IllegalArgumentException();
} finally {
  /* clean up */                                         // Compliant
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/soUbAQ">CERT, ERR05-J.</a> - Do not let checked exceptions escape from a finally block
  </li>
</ul>ZBUG
≤
 squid:LeftCurlyBraceEndLineCheckç
squidLeftCurlyBraceEndLineCheck:An open curly brace should be located at the end of a line"MINOR*java2S1105:ã<p>Sharing some coding conventions is a key point to make it possible for a team to efficiently collaborate. This rule makes it mandatory to place
open curly braces at the end of lines of code.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if(condition)
{
  doSomething();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if(condition) {
  doSomething();
}
</pre>
<h2>Exceptions</h2>
<p>When blocks are inlined (left and right curly braces on the same line), no issue is triggered. </p>
<pre>
if(condition) {doSomething();}
</pre>Z
CODE_SMELL
 

squid:S818ª
squidS818%Literal suffixes should be upper case"MINOR*java:Î<p>Using upper case literal suffixes removes the potential ambiguity between "1" (digit 1) and "l" (letter el) for declaring literals.</p>
<h2>Noncompliant Code Example</h2>
<pre>
long long1 = 1l; // Noncompliant
float float1 = 1.0f; // Noncompliant
double double1 = 1.0d; // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
long long1 = 1L;
float float1 = 1.0F;
double double1 = 1.0D;
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C++:2008, 2-13-4 - Literal suffixes shall be upper case </li>
  <li> MISRA C:2012, 7.3 - The lowercase character "l" shall not be used in a literal suffix </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/koAtAQ">CERT DCL16-C</a> - Use "L," not "l," to indicate a long value </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/n4AtAQ">CERT DCL16-CPP</a> - Use "L," not "l," to indicate a long value </li>
</ul>Z
CODE_SMELL
§
squid:S2250î
squidS22501"ConcurrentLinkedQueue.size()" should not be used"MINOR*java:æ<p>For most collections the <code>size()</code> method requires constant time, but the time required to execute
<code>ConcurrentLinkedQueue.size()</code> is directly proportional to the number of elements in the queue. When the queue is large, this could
therefore be an expensive operation. Further, the results may be inaccurate if the queue is modified during execution.</p>
<p>By the way, if the <code>size()</code> is used only to check that the collection is empty, then the <code>isEmpty()</code> method should be used.
</p>
<h2>Noncompliant Code Example</h2>
<pre>
ConcurrentLinkedQueue queue = new ConcurrentLinkedQueue();
//...
log.info("Queue contains " + queue.size() + " elements");
</pre>ZBUG
æ
squid:S1162Æ
squidS1162'Checked exceptions should not be thrown"MAJOR*java:€<p>The purpose of checked exceptions is to ensure that errors will be dealt with, either by propagating them or by handling them, but some believe
that checked exceptions negatively impact the readability of source code, by spreading this error handling/propagation logic everywhere.</p>
<p>This rule verifies that no method throws a new checked exception.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void myMethod1() throws CheckedException {
  ...
  throw new CheckedException(message);   // Noncompliant
  ...
  throw new IllegalArgumentException(message); // Compliant; IllegalArgumentException is unchecked
}

public void myMethod2() throws CheckedException {  // Compliant; propagation allowed
  myMethod1();
}
</pre>Z
CODE_SMELL
∑
squid:S2130ß
squidS21309Parsing should be used to convert "Strings" to primitives"MINOR*java:…<p>Rather than creating a boxed primitive from a <code>String</code> to extract the primitive value, use the relevant <code>parse</code> method
instead. It will be clearer and more efficient.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String myNum = "12.2";

float f = new Float(myNum).floatValue();  // Noncompliant; creates &amp; discards a Float
</pre>
<h2>Compliant Solution</h2>
<pre>
String myNum = "12.2";

float f = Float.parseFloat(myNum);
</pre>ZBUG
˙
squid:S2251Í
squidS2251IA "for" loop update clause should move the counter in the right direction"MAJOR*java:¸<p>A <code>for</code> loop with a counter that moves in the wrong direction is not an infinite loop. Because of wraparound, the loop will eventually
reach its stop condition, but in doing so, it will run many, many more times than anticipated, potentially causing unexpected behavior. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething(String [] strings) {
  for (int i = 0; i &lt; strings.length; i--) { // Noncompliant;
    String string = strings[i];  // ArrayIndexOutOfBoundsException when i reaches -1
    //...
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(String [] strings) {
  for (int i = 0; i &lt; strings.length; i++) {
    String string = strings[i];
    //...
  }
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/zYEzAg">CERT, MSC54-J.</a> - Avoid inadvertent wrapping of loop counters </li>
</ul>ZBUG
≠
squid:S1160ù
squidS11609Public methods should throw at most one checked exception"MAJOR*java:∏<p>Using checked exceptions forces method callers to deal with errors, either by propagating them or by handling them. Throwing exceptions makes them
fully part of the API of the method.</p>
<p>But to keep the complexity for callers reasonable, methods should not throw more than one kind of checked exception.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void delete() throws IOException, SQLException {      // Noncompliant
  /* ... */
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void delete() throws SomeApplicationLevelException {
  /* ... */
}
</pre>
<h2>Exceptions</h2>
<p>Overriding methods are not checked by this rule and are allowed to throw several checked exceptions.</p>Z
CODE_SMELL
É
squid:S2864Û
squidS2864F"entrySet()" should be iterated when both the key and value are needed"MAJOR*java:à<p>When only the keys from a map are needed in a loop, iterating the <code>keySet</code> makes sense. But when both the key and the value are needed,
it's more efficient to iterate the <code>entrySet</code>, which will give access to both the key and value, instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomethingWithMap(Map&lt;String,Object&gt; map) {
  for (String key : map.keySet()) {  // Noncompliant; for each key the value is retrieved
    Object value = map.get(key);
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomethingWithMap(Map&lt;String,Object&gt; map) {
  for (Map.Entry&lt;String,Object&gt; entry : map.entrySet()) {
    String key = entry.getKey();
    Object value = entry.getValue();
    // ...
  }
}
</pre>ZBUG
â
squid:S1774˘
squidS1774'The ternary operator should not be used"MAJOR*java:¶<p>While the ternary operator is pleasingly compact, its use can make code more difficult to read. It should therefore be avoided in favor of the more
verbose <code>if</code>/<code>else</code> structure.</p>
<h2>Noncompliant Code Example</h2>
<pre>
System.out.println(i&gt;10?"yes":"no");
</pre>
<h2>Compliant Solution</h2>
<pre>
if (i &gt; 10) {
  System.out.println(("yes");
} else {
  System.out.println("no");
}
</pre>Z
CODE_SMELL
¡
squid:ObjectFinalizeCheck£
squidObjectFinalizeCheck1The Object.finalize() method should not be called"MAJOR*java2S1111:∏<p>According to the official javadoc documentation, this Object.finalize() is called by the garbage collector on an object when garbage collection
determines that there are no more references to the object. Calling this method explicitly breaks this contract and so is misleading. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public void dispose() throws Throwable {
  this.finalize();                       // Noncompliant
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/586.html">MITRE, CWE-586</a> - Explicit Call to Finalize() </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/H4cbAQ">CERT, MET12-J.</a> - Do not use finalizers </li>
</ul>ZBUG
€
squid:S1659À
squidS1659:Multiple variables should not be declared on the same line"MINOR*java:Â<p>Declaring multiple variable on one line is difficult to read.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass {

  private int a, b;

  public void method(){
    int c; int d;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {

  private int a;
  private int b;

  public void method(){
    int c;
    int d;
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C++:2008, 8-0-1 - An init-declarator-list or a member-declarator-list shall consist of a single init-declarator or member-declarator
  respectively </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/7wHEAw">CERT, DCL52-J.</a> - Do not declare more than one variable per declaration
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/VgU">CERT, DCL04-C.</a> - Do not declare more than one variable per declaration </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/fAAhAQ">CERT, DCL04-CPP.</a> - Do not declare more than one variable per declaration
  </li>
</ul>Z
CODE_SMELL
À
squid:ParsingError¥
squidParsingErrorJava parser failure"MAJOR*java2S2260:Á<p>When the Java parser fails, it is possible to record the failure as a violation on the file. This way, not only it is possible to track the number
of files that do not parse but also to easily find out why they do not parse.</p>Z
CODE_SMELL
…
squid:S1656π
squidS1656%Variables should not be self-assigned"MAJOR*java:Ô<p>There is no reason to re-assign a variable to itself. Either this statement is redundant and should be removed, or the re-assignment is a mistake
and some other value or variable was intended for the assignment instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void setName(String name) {
  name = name;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void setName(String name) {
  this.name = name;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>ZBUG
£
squid:S1301ì
squidS13019"switch" statements should have at least 3 "case" clauses"MINOR*java:Æ<p><code>switch</code> statements are useful when there are many different cases depending on the value of the same expression.</p>
<p>For just one or two cases however, the code will be more readable with <code>if</code> statements.</p>
<h2>Noncompliant Code Example</h2>
<pre>
switch (variable) {
  case 0:
    doSomething();
    break;
  default:
    doSomethingElse();
    break;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if (variable == 0) {
  doSomething();
} else {
  doSomethingElse();
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 15.5 - Every switch statement shall have at least one case clause. </li>
  <li> MISRA C++:2008, 6-4-8 - Every switch statement shall have at least one case-clause. </li>
  <li> MISRA C:2012, 16.6 - Every switch statement shall have at least two switch-clauses </li>
</ul>Z
CODE_SMELL
’
squid:S1309≈
squidS1309-Track uses of "@SuppressWarnings" annotations"INFO*java:Ì<p>This rule allows you to track the usage of the <code>@SuppressWarnings</code> mechanism.</p>
<h2>Noncompliant Code Example</h2>
<p>With a parameter value of "unused" :</p>
<pre>
@SuppressWarnings("unused")
</pre>
<h2>Compliant Solution</h2>
<p>With the default parameter value of "all":</p>
<pre>
@SuppressWarnings("unchecked")
@SuppressWarnings("unused")
</pre>Z
CODE_SMELL
’	
squid:S2638≈	
squidS2638,Method overrides should not change contracts"CRITICAL*java:Í<p>Because a subclass instance may be cast to and treated as an instance of the superclass, overriding methods should uphold the aspects of the
superclass contract that relate to the Liskov Substitution Principle. Specifically, if the parameters or return type of the superclass method are
marked with any of the following: <code>@Nullable</code>, <code>@CheckForNull</code>, <code>@NotNull</code>, <code>@NonNull</code>, and
<code>@Nonnull</code>, then subclass parameters are not allowed to tighten the contract, and return values are not allowed to loosen it.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit {

  private Season ripe;
  private String color;

  public void setRipe(@Nullable Season ripe) {
    this.ripe = ripe;
  }

  public @NotNull Integer getProtein() {
    return 12;
  }
}

public class Raspberry extends Fruit {

  public void setRipe(@NotNull Season ripe) {  // Noncompliant
    this.ripe = ripe;
  }

  public @Nullable Integer getProtein() {  // Noncompliant
    return null;
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> https://en.wikipedia.org/wiki/Liskov_substitution_principle </li>
</ul>Z
CODE_SMELL
¥
squid:S2639§
squidS26394Inappropriate regular expressions should not be used"MAJOR*java:À<p>Regular expressions are powerful but tricky, and even those long used to using them can make mistakes.</p>
<p>The following should not be used as regular expressions:</p>
<ul>
  <li> <code>.</code> - matches any single character. Used in <code>replaceAll</code>, it matches <em>everything</em> </li>
  <li> <code>|</code> - normally used as an option delimiter. Used stand-alone, it matches the space between characters </li>
  <li> <code>File.separator</code> - matches the platform-specific file path delimiter. On Windows, this will be taken as an escape character </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
String str = "/File|Name.txt";

String clean = str.replaceAll(".",""); // Noncompliant; probably meant to remove only dot chars, but returns an empty string
String clean2 = str.replaceAll("|","_"); // Noncompliant; yields _/_F_i_l_e_|_N_a_m_e_._t_x_t_
String clean3 = str.replaceAll(File.separator,""); // Noncompliant; exception on Windows
</pre>ZBUG
ì
squid:S3725É
squidS3725*Java 8's "Files.exists" should not be used"MAJOR*java:¥<p>The <code>Files.exists</code> method has noticeably poor performance in JDK 8, and can slow an application significantly when used to check files
that don't actually exist. </p>
<p>The same goes for <code>Files.notExists</code>, <code>Files.isDirectory</code> and <code>Files.isRegularFile</code>.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is not 8.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Path myPath;
if(java.nio.Files.exists(myPath)) {  // Noncompliant
 // do something
}
</pre>
<h2>Compliant Solution</h2>
<pre>
Path myPath;
if(myPath.toFile().exists())) {
 // do something
}
</pre>
<h2>See</h2>
<ul>
  <li> https://bugs.openjdk.java.net/browse/JDK-8153414 </li>
  <li> https://bugs.openjdk.java.net/browse/JDK-8154077 </li>
</ul>ZBUG
è
squid:S2637ˇ
squidS2637+"@NonNull" values should not be set to null"MINOR*java:Ø<p>Fields, parameters and return values marked <code>@NotNull</code>, <code>@NonNull</code>, or <code>@Nonnull</code> are assumed to have non-null
values and are not typically null-checked before use. Therefore setting one of these values to <code>null</code>, or failing to set such a class field
in a constructor, could cause <code>NullPointerException</code>s at runtime.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MainClass {

  @Nonnull
  private String primary;
  private String secondary;

  public MainClass(String color) {
    if (color != null) {
      secondary = null;
    }
    primary = color;  // Noncompliant; "primary" is Nonnull but could be set to null here
  }

  public MainClass() { // Noncompliant; "primary" Nonnull" but is not initialized
  }

  @Nonnull
  public String indirectMix() {
    String mix = null;
    return mix;  // Noncompliant; return value is Nonnull, but null is returned.}}
  }
</pre>ZBUG
´
squid:S1994õ
squidS1994\"for" loop incrementers should modify the variable being tested in the loop's stop condition"MAJOR*java:ö<p>It is almost always an error when a <code>for</code> loop's stop condition and incrementer don't act on the same variable. Even when it is not, it
could confuse future maintainers of the code, and should be avoided.</p>
<h2>Noncompliant Code Example</h2>
<pre>
for (i = 0; i &lt; 10; j++) {  // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
for (i = 0; i &lt; 10; i++) {
  // ...
}
</pre>ZBUG
À

squid:S1872ª

squidS1872&Classes should not be compared by name"MAJOR*java:	<p>There is no requirement that class names be unique, only that they be unique within a package. Therefore trying to determine an object's type based
on its class name is an exercise fraught with danger. One of those dangers is that a malicious user will send objects of the same name as the trusted
class and thereby gain trusted access. </p>
<p>Instead, the <code>instanceof</code> operator should be used to check the object's underlying type.</p>
<h2>Noncompliant Code Example</h2>
<pre>
package computer;
class Pear extends Laptop { ... }

package food;
class Pear extends Fruit { ... }

class Store {

  public boolean hasSellByDate(Object item) {
    if ("Pear".equals(item.getClass().getSimpleName())) {  // Noncompliant
      return true;  // Results in throwing away week-old computers
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class Store {

  public boolean hasSellByDate(Object item) {
    if (item instanceof food.Pear) {
      return true;
    }
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/486.html">MITRE, CWE-486</a> - Comparison of Classes by Name </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/LAFlAQ">CERT, OBJ09-J.</a> - Compare classes and not class names </li>
</ul>ZBUG
‡
squid:S1871–
squidS1871^Two branches in the same conditional structure should not have exactly the same implementation"MINOR*java:Õ<p>Having two <code>cases</code> in the same <code>switch</code> statement or branches in the same <code>if</code> structure with the same
implementation is at best duplicate code, and at worst a coding error. If the same logic is truly needed for both instances, then in an
<code>if</code> structure they should be combined, or for a <code>switch</code>, one should fall through to the other. </p>
<p>Moreover when the second and third operands of a ternary operator are the same, the operator will always return the same value regardless of the
condition. Either the operator itself is pointless, or a mistake was made in coding it.</p>
<h2>Noncompliant Code Example</h2>
<pre>
switch (i) {
  case 1:
    doSomething();
    break;
  case 2:
    doSomethingDifferent();
    break;
  case 3:  // Noncompliant; duplicates case 1's implementation
    doSomething();
    break;
  default:
    doTheRest();
}

if (a &gt;= 0 &amp;&amp; a &lt; 10) {
  doTheThing();
}
else if (a &gt;= 10 &amp;&amp; a &lt; 20) {
  doTheOtherThing();
}
else if (a &gt;= 20 &amp;&amp; a &lt; 50) {
  doTheThing();  // Noncompliant; duplicates first condition
}
else {
  doTheRest();
}

if (b == 0) {
  doOneMoreThing();
}
else {
  doOneMoreThing(); // Noncompliant; duplicates then-branch
}

int b = a &gt; 12 ? 4 : 4;  // Noncompliant; always results in the same value
</pre>
<h2>Compliant Solution</h2>
<pre>
switch (i) {
  case 1:
  case 3:
    doSomething();
    break;
  case 2:
    doSomethingDifferent();
    break;
  default:
    doTheRest();
}

if ((a &gt;= 0 &amp;&amp; a &lt; 10) || (a &gt;= 20 &amp;&amp; a &lt; 50)) {
  doTheThing();
}
else if (a &gt;= 10 &amp;&amp; a &lt; 20) {
  doTheOtherThing();
}
else {
  doTheRest();
}

doOneMoreThing();

int b = 4;
</pre>
<p>or </p>
<pre>
switch (i) {
  case 1:
    doSomething();
    break;
  case 2:
    doSomethingDifferent();
    break;
  case 3:
    doThirdThing();
    break;
  default:
    doTheRest();
}

if (a &gt;= 0 &amp;&amp; a &lt; 10) {
  doTheThing();
}
else if (a &gt;= 10 &amp;&amp; a &lt; 20) {
  doTheOtherThing();
}
else if (a &gt;= 20 &amp;&amp; a &lt; 50) {
  doTheThirdThing();
}
else {
  doTheRest();
}

if (b == 0) {
  doOneMoreThing();
}
else {
  doTheRest();
}

int b = a &gt; 12 ? 4 : 8;
</pre>ZBUG
π
squid:S1996©
squidS1996?Files should contain only one top-level class or interface each"MAJOR*java:æ<p>A file that grows too much tends to aggregate too many responsibilities and inevitably becomes harder to understand and therefore to maintain. This
is doubly true for a file with multiple top-level classes and interfaces. It is strongly advised to divide the file into one top-level class or
interface per file.</p>Z
CODE_SMELL
ﬂ
squid:CommentedOutCodeLine¿
squidCommentedOutCodeLine.Sections of code should not be "commented out""MAJOR*java2S125:—<p>Programmers should not comment out code as it bloats programs and reduces readability.</p>
<p>Unused code should be deleted and can be retrieved from source control history if required.</p>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 2.4 - Sections of code should not be "commented out". </li>
  <li> MISRA C++:2008, 2-7-2 - Sections of code shall not be "commented out" using C-style comments. </li>
  <li> MISRA C++:2008, 2-7-3 - Sections of code should not be "commented out" using C++ comments. </li>
  <li> MISRA C:2012, Dir. 4.4 - Sections of code should not be "commented out" </li>
</ul>Z
CODE_SMELL
¡
squid:S2973±
squidS2973-Escaped Unicode characters should not be used"MAJOR*java:ÿ<p>The use of Unicode escape sequences should be reserved for characters that would otherwise be ambiguous, such as unprintable characters.</p>
<p>This rule ignores sequences composed entirely of Unicode characters, but otherwise raises an issue for each Unicode character that represents a
printable character.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String prefix = "n\u00E9e"; // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
String prefix = "n√©e";
</pre>Z
CODE_SMELL
ô
squid:S1643â
squidS16436Strings should not be concatenated using '+' in a loop"MINOR*java:Æ<p>Strings are immutable objects, so concatenation doesn't simply add the new String to the end of the existing string. Instead, in each loop
iteration, the first String is converted to an intermediate object type, the second string is appended, and then the intermediate object is converted
back to a String. Further, performance of these intermediate operations degrades as the String gets longer. Therefore, the use of StringBuilder is
preferred.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String str = "";
for (int i = 0; i &lt; arrayOfStrings.length ; ++i) {
  str = str + arrayOfStrings[i];
}
</pre>
<h2>Compliant Solution</h2>
<pre>
StringBuilder bld = new StringBuilder();
  for (int i = 0; i &lt; arrayOfStrings.length; ++i) {
    bld.append(arrayOfStrings[i]);
  }
  String str = bld.toString();
</pre>ZBUG
ô
squid:S2974â
squidS29747Classes without "public" constructors should be "final""MINOR*java:¶<p>Classes with only <code>private</code> constructors should be marked <code>final</code> to prevent any mistaken extension attempts.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class PrivateConstructorClass {  // Noncompliant
  private PrivateConstructorClass() {
    // ...
  }

  public static int magic(){
    return 42;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public final class PrivateConstructorClass {  // Compliant
  private PrivateConstructorClass() {
    // ...
  }

  public static int magic(){
    return 42;
  }
}
</pre>Z
CODE_SMELL
À
squid:S1641ª
squidS1641GSets with elements that are enum values should be replaced with EnumSet"MINOR*java:œ<p>When all the elements in a Set are values from the same enum, the Set can be replaced with an EnumSet, which can be much more efficient than other
sets because the underlying data structure is a simple bitmap.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  public enum COLOR {
    RED, GREEN, BLUE, ORANGE;
  }

  public void doSomething() {
    Set&lt;COLOR&gt; warm = new HashSet&lt;COLOR&gt;();
    warm.add(COLORS.RED);
    warm.add(COLORS.ORANGE);
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {

  public enum COLOR {
    RED, GREEN, BLUE, ORANGE;
  }

  public void doSomething() {
    EnumSet&lt;COLOR&gt; warm = EnumSet.of(COLOR.RED, COLOR.ORANGE);
  }
}
</pre>ZBUG
∏
squid:S2972®
squidS29724Inner classes should not have too many lines of code"MAJOR*java:»<p>Inner classes should be short and sweet, to manage complexity in the overall file. An inner class that has grown longer than a certain threshold
should probably be externalized to its own file.</p>Z
CODE_SMELL
«
squid:S1640∑
squidS1640CMaps with keys that are enum values should be replaced with EnumMap"MINOR*java:œ<p>When all the keys of a Map are values from the same enum, the <code>Map</code> can be replaced with an <code>EnumMap</code>, which can be much more
efficient than other sets because the underlying data structure is a simple array.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  public enum COLOR {
    RED, GREEN, BLUE, ORANGE;
  }

  public void mapMood() {
    Map&lt;COLOR, String&gt; moodMap = new HashMap&lt;COLOR, String&gt; ();
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {

  public enum COLOR {
    RED, GREEN, BLUE, ORANGE;
  }

  public void mapMood() {
    EnumMap&lt;COLOR, String&gt; moodMap = new EnumMap&lt;COLOR, String&gt; (COLOR.class);
  }
}
</pre>ZBUG
•
squid:S2970ï
squidS2970Assertions should be complete"BLOCKER*java: <p>It is very easy to write incomplete assertions when using some test frameworks. This rule enforces complete assertions in the following cases:</p>
<ul>
  <li> Fest: <code>assertThat</code> is not followed by an assertion invocation </li>
  <li> AssertJ: <code>assertThat</code> is not followed by an assertion invocation </li>
  <li> Mockito: <code>verify</code> is not followed by a method invocation </li>
</ul>
<p>In such cases, what is intended to be a test doesn't actually verify anything</p>
<h2>Noncompliant Code Example</h2>
<pre>
// Fest
boolean result = performAction();
// let's now check that result value is true
assertThat(result); // Noncompliant; nothing is actually checked, the test passes whether "result" is true or false

// Mockito
List mockedList = Mockito.mock(List.class);
mockedList.add("one");
mockedList.clear();
// let's check that "add" and "clear" methods are actually called
Mockito.verify(mockedList); // Noncompliant; nothing is checked here, oups no call is chained to verify()
</pre>
<h2>Compliant Solution</h2>
<pre>
// Fest
boolean result = performAction();
// let's now check that result value is true
assertThat(result).isTrue();

// Mockito
List mockedList = Mockito.mock(List.class);
mockedList.add("one");
mockedList.clear();
// let's check that "add" and "clear" methods are actually called
Mockito.verify(mockedList).add("one");
Mockito.verify(mockedList).clear();
</pre>
<h2>Exceptions</h2>
<p>Variable assignments and return statements are skipped to allow helper methods.</p>
<pre>
private BooleanAssert check(String filename, String key) {
  String fileContent = readFileContent(filename);
  performReplacements(fileContent);
  return assertThat(fileContent.contains(key)); // No issue is raised here
}

@Test
public void test() {
  check("foo.txt", "key1").isTrue();
  check("bar.txt", "key2").isTrue();
}
</pre>Z
CODE_SMELL
Ÿ
squid:S2975…
squidS2975 "clone" should not be overridden"BLOCKER*java:˚<p>Many consider <code>clone</code> and <code>Cloneable</code> broken in Java, largely because the rules for overriding <code>clone</code> are tricky
and difficult to get right, according to Joshua Bloch:</p>
<blockquote>
  Object's clone method is very tricky. It's based on field copies, and it's "extra-linguistic." It creates an object without calling a constructor.
  There are no guarantees that it preserves the invariants established by the constructors. There have been lots of bugs over the years, both in and
  outside Sun, stemming from the fact that if you just call super.clone repeatedly up the chain until you have cloned an object, you have a shallow
  copy of the object. The clone generally shares state with the object being cloned. If that state is mutable, you don't have two independent objects.
  If you modify one, the other changes as well. And all of a sudden, you get random behavior.
</blockquote>
<p>A copy constructor or copy factory should be used instead.</p>
<p>This rule raises an issue when <code>clone</code> is overridden, whether or not <code>Cloneable</code> is implemented.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {
  // ...

  public Object clone() { // Noncompliant
    //...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {
  // ...

  MyClass (MyClass source) {
    //...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://www.artima.com/intv/bloch13.html">Copy Constructor versus Cloning</a> </li>
</ul>
<h3>See Also</h3>
<ul>
  <li> <a href='/coding_rules#rule_key=squid%3AS2157'>S2157</a> - "Cloneables" should implement "clone" </li>
  <li> <a href='/coding_rules#rule_key=squid%3AS1182'>S1182</a> - Classes that override "clone" should be "Cloneable" and call "super.clone()" </li>
</ul>Z
CODE_SMELL
√

squid:S2976≥

squidS2976>"File.createTempFile" should not be used to create a directory"CRITICAL*java:√	<p>Using <code>File.createTempFile</code> as the first step in creating a temporary directory causes a race condition and is inherently unreliable and
insecure. Instead, <code>Files.createTempDirectory</code> (Java 7+) or a library function such as Guava's similarly-named
<code>Files.createTempDir</code> should be used.</p>
<p>This rule raises an issue when the following steps are taken in immediate sequence:</p>
<ul>
  <li> call to <code>File.createTempFile</code> </li>
  <li> delete resulting file </li>
  <li> call <code>mkdir</code> on the File object </li>
</ul>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>7</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
File tempDir;
tempDir = File.createTempFile("", ".");
tempDir.delete();
tempDir.mkdir();  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
Path tempPath = Files.createTempDirectory("");
File tempDir = tempPath.toFile();
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A9-Using_Components_with_Known_Vulnerabilities">OWAPS Top Ten 2013 Category A9</a> - Using
  Components with Known Vulnerabilities </li>
</ul>ZVULNERABILITY
≤	
4squid:ObjectFinalizeOverridenCallsSuperFinalizeCheck˘
squid.ObjectFinalizeOverridenCallsSuperFinalizeCheckU"super.finalize()" should be called at the end of "Object.finalize()" implementations"CRITICAL*java2S1114:Ã<p>Overriding the <code>Object.finalize()</code> method must be done with caution to dispose some system resources.</p>
<p>Calling the <code>super.finalize()</code> at the end of this method implementation is highly recommended in case parent implementations must also
dispose some system resources.</p>
<h2>Noncompliant Code Example</h2>
<pre>
protected void finalize() {   // Noncompliant; no call to super.finalize();
  releaseSomeResources();
}

protected void finalize() {
  super.finalize();  // Noncompliant; this call should come last
  releaseSomeResources();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
protected void finalize() {
  releaseSomeResources();
  super.finalize();
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/568.html">MITRE, CWE-568</a> - finalize() Method Without super.finalize() </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/H4cbAQ">CERT, MET12-J.</a> - Do not use finalizers </li>
</ul>ZBUG
å
squid:EmptyFile¯
squid	EmptyFileFiles should not be empty"MINOR*java2S2309:®<p>Files with no lines of code clutter a project and should be removed. </p>
<h2>Noncompliant Code Example</h2>
<pre>
//package org.foo;
//
//public class Bar {}
</pre>Z
CODE_SMELL
≥
squid:S2786£
squidS2786,Nested "enum"s should not be declared static"MINOR*java:À<p>According to <a href="http://docs.oracle.com/javase/specs/jls/se7/html/jls-8.html#jls-8.9">the docs</a>:</p>
<blockquote>
  Nested enum types are implicitly
  <code>static</code>.
</blockquote>
<p>So there's no need to declare them <code>static</code> explicitly.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Flower {
  static enum Color { // Noncompliant; static is redundant here
    RED, YELLOW, BLUE, ORANGE
  }

  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Flower {
  enum Color { // Compliant
    RED, YELLOW, BLUE, ORANGE
  }

  // ...
}
</pre>Z
CODE_SMELL
Ñ
squid:S1698Ù
squidS1698*Objects should be compared with "equals()""MAJOR*java:•<p>Using the equality (<code>==</code>) and inequality (<code>!=</code>) operators to compare two objects does not check to see if they have the same
values. Rather it checks to see if both object references point to exactly the same object in memory. The vast majority of the time, this is not what
you want to do. Use the <code>.equals()</code> method to compare the values of two objects or to compare a string object to a string literal.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String str1 = "blue";
String str2 = "blue";
String str3 = str1;

if (str1 == str2)
{
  System.out.println("they're both 'blue'"); // this doesn't print because the objects are different
}

if (str1 == "blue")
{
  System.out.println("they're both 'blue'"); // this doesn't print because the objects are different
}

if (str1 == str3)
{
  System.out.println("they're the same object"); // this prints
}
</pre>
<h2>Compliant Solution</h2>
<pre>
String str1 = "blue";
String str2 = "blue";
String str3 = str1;

if (str1.equals(str2))
{
  System.out.println("they're both 'blue'"); // this prints
}

if (str1.equals("blue"))
{
  System.out.println("they're both 'blue'"); // this prints
}

if (str1 == str3)
{
  System.out.println("they're the same object"); // this still prints, but it's probably not what you meant to do
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/595.html">MITRE, CWE-595</a> - Comparison of Object References Instead of Object Contents </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/597">MITRE, CWE-597</a> - Use of Wrong Operator in String Comparison </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/wwD1AQ">CERT, EXP03-J.</a> - Do not use the equality operators when comparing values of
  boxed primitives </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/8AEqAQ">CERT, EXP50-J.</a> - Do not confuse abstract object equality with reference
  equality </li>
</ul>ZBUG
’

squid:S1214≈

squidS1214-Constants should not be defined in interfaces"CRITICAL*java:È	<p>According to Joshua Bloch, author of "Effective Java":</p>
<blockquote>
  <p>The constant interface pattern is a poor use of interfaces. </p>
  <p>That a class uses some constants internally is an implementation detail.</p>
  <p>Implementing a constant interface causes this implementation detail to leak into the class's exported API. It is of no consequence to the users
  of a class that the class implements a constant interface. In fact, it may even confuse them. Worse, it represents a commitment: if in a future
  release the class is modified so that it no longer needs to use the constants, it still must implement the interface to ensure binary compatibility.
  If a nonfinal class implements a constant interface,</p>
  <p>all of its subclasses will have their namespaces polluted by the constants in the interface.</p>
</blockquote>
<h2>Noncompliant Code Example</h2>
<pre>
interface Status {                      // Noncompliant
   int OPEN = 1;
   int CLOSED = 2;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public enum Status {                    // Compliant
  OPEN,
  CLOSED;
}
</pre>
<p>or</p>
<pre>
public final class Status {             // Compliant
   public static final int OPEN = 1;
   public static final int CLOSED = 2;
}
</pre>Z
CODE_SMELL
ª
squid:S1697´
squidS1697WShort-circuit logic should be used to prevent null pointer dereferences in conditionals"MAJOR*java:Ø<p>When either the equality operator in a null test or the logical operator that follows it is reversed, the code has the appearance of safely
null-testing the object before dereferencing it. Unfortunately the effect is just the opposite - the object is null-tested and then dereferenced
<em>only</em> if it is null, leading to a guaranteed null pointer dereference.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if (str == null &amp;&amp; str.length() == 0) {
  System.out.println("String is empty");
}

if (str != null || str.length() &gt; 0) {
  System.out.println("String is not empty");
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if (str == null || str.length() == 0) {
  System.out.println("String is empty");
}

if (str != null &amp;&amp; str.length() &gt; 0) {
  System.out.println("String is not empty");
}
</pre>
<h2>Deprecated</h2>
<p>This rule is deprecated; use <a href='/coding_rules#rule_key=squid%3AS2259'>S2259</a> instead.</p>ZBUG
õ
squid:S1213ã
squidS1213UThe members of an interface declaration or class should appear in a pre-defined order"MINOR*java:ä<p>According to the Java Code Conventions as defined by Oracle, the members of a class or interface declaration should appear in the following order
in the source files:</p>
<ul>
  <li> Class and instance variables </li>
  <li> Constructors </li>
  <li> Methods </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo{
   private int field = 0;
   public boolean isTrue() {...}
   public Foo() {...}                         // Noncompliant, constructor defined after methods
   public static final int OPEN = 4;  //Noncompliant, variable defined after constructors and methods
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo{
   public static final int OPEN = 4;
   private int field = 0;
   public Foo() {...}
   public boolean isTrue() {...}
}
</pre>Z
CODE_SMELL
Œ
squid:S3631æ
squidS36313"Arrays.stream" should be used for primitive arrays"MINOR*java:Ê<p>For arrays of objects, <code>Arrays.asList(T ... a).stream()</code> and <code>Arrays.stream(array)</code> are basically equivalent in terms of
performance. However, for arrays of primitives, using <code>Arrays.asList</code> will force the construction of a list of boxed types, and then use
<em>that</em> last as a stream. On the other hand, <code>Arrays.stream</code> uses the appropriate primitive stream type (<code>IntStream</code>,
<code>LongStream</code>, <code>DoubleStream</code>) when applicable, with much better performance.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Arrays.asList("a1", "a2", "b1", "c2", "c1").stream()
    .filter(...)
    .forEach(...);

Arrays.asList(1, 2, 3, 4).stream() // Noncompliant
    .filter(...)
    .forEach(...);
</pre>
<h2>Compliant Solution</h2>
<pre>
Arrays.asList("a1", "a2", "b1", "c2", "c1").stream()
    .filter(...)
    .forEach(...);

int[] intArray = new int[]{1, 2, 3, 4};
Arrays.stream(intArray)
    .filter(...)
    .forEach(...);
</pre>ZBUG
∞	
squid:S1696†	
squidS1696+"NullPointerException" should not be caught"MAJOR*java:…<p><code>NullPointerException</code> should be avoided, not caught. Any situation in which <code>NullPointerException</code> is explicitly caught can
easily be converted to a <code>null</code> test, and any behavior being carried out in the catch block can easily be moved to the "is null" branch of
the conditional.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int lengthPlus(String str) {
  int len = 2;
  try {
    len += str.length();
  }
  catch (NullPointerException e) {
    log.info("argument was null");
  }
  return len;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public int lengthPlus(String str) {
  int len = 2;

  if (str != null) {
    len += str.length();
  }
  else {
    log.info("argument was null");
  }
  return len;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/395.html">MITRE, CWE-395</a> - Use of NullPointerException Catch to Detect NULL Pointer
  Dereference </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/BIB3AQ">CERT, ERR08-J.</a> - Do not catch NullPointerException or any of its ancestors
  </li>
</ul>Z
CODE_SMELL
‘	
squid:S2301ƒ	
squidS23014Public methods should not contain selector arguments"MAJOR*java:‰<p>A selector argument is a <code>boolean</code> argument that's used to determine which of two paths to take through a method. Specifying such a
parameter may seem innocuous, particularly if it's well named. </p>
<p>Unfortunately, the maintainers of the code calling the method won't see the parameter name, only its value. They'll be forced either to guess at
the meaning or to take extra time to look the method up.</p>
<p>Instead, separate methods should be written.</p>
<p>This rule finds methods with a <code>boolean</code> that's used to determine which path to take through the method.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public String tempt(String name, boolean ofAge) {
  if (ofAge) {
    offerLiquor(name);
  } else {
    offerCandy(name);
  }
}

// ...
public void corrupt() {
  tempt("Joe", false); // does this mean not to temp Joe?
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void temptAdult(String name) {
  offerLiquor(name);
}

public void temptChild(String name) {
    offerCandy(name);
}

// ...
public void corrupt() {
  age &lt; legalAge ? temptChild("Joe") : temptAdult("Joe");
}
</pre>Z
CODE_SMELL
å
squid:S1695¸
squidS16956"NullPointerException" should not be explicitly thrown"MAJOR*java:ö<p>A <code>NullPointerException</code> should indicate that a <code>null</code> value was unexpectedly encountered. Good programming practice dictates
that code is structured to avoid NPE's. </p>
<p>Explicitly throwing <code>NullPointerException</code> forces a method's callers to explicitly catch it, rather than coding to avoid it. Further, it
makes it difficult to distinguish between the unexpectedly-encountered <code>null</code> value and the condition which causes the method to purposely
throw an NPE.</p>
<p>If an NPE is being thrown to indicate that a parameter to the method should not have been null, use the <code>@NotNull</code> annotation
instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething (String aString) throws NullPointerException {
     throw new NullPointerException();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething (@NotNull String aString) {
}
</pre>Z
CODE_SMELL
§
squid:S1694î
squidS1694@An abstract class should have both abstract and concrete methods"MINOR*java:®
<p>The purpose of an abstract class is to provide some heritable behaviors while also defining methods which must be implemented by sub-classes.</p>
<p>A class with no abstract methods that was made abstract purely to prevent instantiation should be converted to a concrete class (i.e. remove the
<code>abstract</code> keyword) with a private constructor.</p>
<p>A class with only abstract methods and no inheritable behavior should be converted to an interface.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public abstract class Animal {  // Noncompliant; should be an interface
  abstract void move();
  abstract void feed();
}

public abstract class Color {  // Noncompliant; should be concrete with a private constructor
  private int red = 0;
  private int green = 0;
  private int blue = 0;

  public int getRed() {
    return red;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public interface Animal {
  void move();
  void feed();
}

public class Color {
  private int red = 0;
  private int green = 0;
  private int blue = 0;

  private Color () {}

  public int getRed() {
    return red;
  }
}

public abstract class Lamp {

  private boolean switchLamp=false;

  public abstract void glow();

  public void flipSwitch() {
    switchLamp = !switchLamp;
    if (switchLamp) {
      glow();
    }
  }
}
</pre>Z
CODE_SMELL
Î
squid:S1452€
squidS1452>Generic wildcard types should not be used in return parameters"CRITICAL*java:Ó<p>Using a wildcard as a return type implicitly means that the return value should be considered read-only, but without any way to enforce this
contract. </p>
<p>Let's take the example of method returning a "List&lt;? extends Animal&gt;". Is it possible on this list to add a Dog, a Cat, ... we simply don't
know. The consumer of a method should not have to deal with such disruptive questions. </p>
<h2>Noncompliant Code Example</h2>
<pre>
List&lt;? extends Animal&gt; getAnimals(){...}
</pre>Z
CODE_SMELL
µ

squid:S1210•

squidS1210R"equals(Object obj)" should be overridden along with the "compareTo(T obj)" method"MINOR*java:Æ	<p>According to the Java <code>Comparable.compareTo(T o)</code> documentation:</p>
<blockquote>
  <p>It is strongly recommended, but not strictly required that <code>(x.compareTo(y)==0) == (x.equals(y))</code>.</p>
  <p>Generally speaking, any class that implements the Comparable interface and violates this condition should clearly indicate this fact.</p>
  <p>The recommended language is "Note: this class has a natural ordering that is inconsistent with equals." </p>
</blockquote>
<p>If this rule is violated, weird and unpredictable failures can occur.</p>
<p>For example, in Java 5 the <code>PriorityQueue.remove()</code> method relied on <code>compareTo()</code>, but since Java 6 it has relied on
<code>equals()</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo implements Comparable&lt;Foo&gt; {
  @Override
  public int compareTo(Foo foo) { /* ... */ }      // Noncompliant as the equals(Object obj) method is not overridden
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo implements Comparable&lt;Foo&gt; {
  @Override
  public int compareTo(Foo foo) { /* ... */ }      // Compliant

  @Override
  public boolean equals(Object obj) { /* ... */ }
}
</pre>ZBUG
ı	
squid:S1451Â	
squidS1451+Track lack of copyright and license headers"BLOCKER*java:å	<p>Each source file should start with a header stating file ownership and the license which must be used to distribute the application. </p>
<p>This rule must be fed with the header text that is expected at the beginning of every file.</p>
<h2>Compliant Solution</h2>
<pre>
/*
 * SonarQube, open source software quality management tool.
 * Copyright (C) 2008-2013 SonarSource
 * mailto:contact AT sonarsource DOT com
 *
 * SonarQube is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * SonarQube is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
</pre>Z
CODE_SMELL
´
squid:S3518õ
squidS3518)Zero should not be a possible denominator"CRITICAL*java: <p>If the denominator to a division or modulo operation is zero it would result in a fatal error.</p>
<h2>Noncompliant Code Example</h2>
<pre>
void test_divide() {
  int z = 0;
  if (unknown()) {
    // ..
    z = 3;
  } else {
    // ..
  }
  z = 1 / z; // Noncompliant, possible division by zero
}
</pre>
<h2>Compliant Solution</h2>
<pre>
void test_divide() {
  int z = 0;
  if (unknown()) {
    // ..
    z = 3;
  } else {
    // ..
    z = 1;
  }
  z = 1 / z;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://cwe.mitre.org/data/definitions/369.html">MITRE, CWE-369</a> - Divide by zero </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/KAGyAw">CERT, NUM02-J.</a> - Ensure that division and remainder operations do not
  result in divide-by-zero errors </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/cAI">CERT, INT33-C.</a> - Ensure that division and remainder operations do not result
  in divide-by-zero errors </li>
</ul>ZBUG
ô
squid:S1219â
squidS12196"switch" statements should not contain non-case labels"MAJOR*java:Æ
<p>Even if it is legal, mixing case and non-case labels in the body of a switch statement is very confusing and can even be the result of a typing
error.</p>
<h2>Noncompliant Code Example</h2>
<pre>
switch (day) {
  case MONDAY:
  case TUESDAY:
  WEDNESDAY:   // Noncompliant; syntactically correct, but behavior is not what's expected
    doSomething();
    break;
  ...
}

switch (day) {
  case MONDAY:
    break;
  case TUESDAY:
    foo:for(int i = 0 ; i &lt; X ; i++) {  // Noncompliant; the code is correct and behaves as expected but is barely readable
         /* ... */
        break foo;  // this break statement doesn't relate to the nesting case TUESDAY
         /* ... */
    }
    break;
    /* ... */
}
</pre>
<h2>Compliant Solution</h2>
<pre>
switch (day) {
  case MONDAY:
  case TUESDAY:
  case WEDNESDAY:
    doSomething();
    break;
  ...
}

switch (day) {
  case MONDAY:
    break;
  case TUESDAY:
    compute(args); // put the content of the labelled "for" statement in a dedicated method
    break;

    /* ... */
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 15.0 - The MISRA C <em>switch</em> syntax shall be used. </li>
  <li> MISRA C++:2008, 6-4-3 - A switch statement shall be a well-formed switch statement. </li>
  <li> MISRA C:2012, 16.1 - All switch statements shall be well-formed </li>
</ul>ZBUG
ò
squid:S1217à
squidS1217*Thread.run() should not be called directly"MAJOR*java:π<p>The purpose of the <code>Thread.run()</code> method is to execute code in a separate, dedicated thread. Calling this method directly doesn't make
sense because it causes its code to be executed in the current thread. </p>
<p>To get the expected behavior, call the <code>Thread.start()</code> method instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Thread myThread = new Thread(runnable);
myThread.run(); // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
Thread myThread = new Thread(runnable);
myThread.start(); // Compliant
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/572.html">MITRE, CWE-572</a> - Call to Thread run() instead of start() </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/KQAiAg">CERT THI00-J.</a> - Do not invoke Thread.run() </li>
</ul>ZBUG
”
squid:S2789√
squidS2789)"null" should not be used with "Optional""MAJOR*java:ı<p>The concept of <code>Optional</code> is that it will be used when <code>null</code> could cause errors. In a way, it replaces <code>null</code>,
and when <code>Optional</code> is in use, there should never be a question of returning or receiving <code>null</code> from a call.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething () {
  Optional&lt;String&gt; optional = getOptional();
  if (optional != null) {  // Noncompliant
    // do something with optional...
  }
}

@Nullable // Noncompliant
public Optional&lt;String&gt; getOptional() {
  // ...
  return null;  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething () {
  Optional&lt;String&gt; optional = getOptional();
  optional.ifPresent(
    // do something with optional...
  );
}

public Optional&lt;String&gt; getOptional() {
  // ...
  return Optional.empty();
}
</pre>ZBUG
˜
squid:S1699Á
squidS16995Constructors should only call non-overridable methods"CRITICAL*java:É<p>Calling an overridable method from a constructor could result in failures or strange behaviors when instantiating a subclass which overrides the
method.</p>
<p>For example:</p>
<ul>
  <li> The subclass class constructor starts by contract by calling the parent class constructor. </li>
  <li> The parent class constructor calls the method, which has been overridden in the child class. </li>
  <li> If the behavior of the child class method depends on fields that are initialized in the child class constructor, unexpected behavior (like a
  <code>NullPointerException</code>) can result, because the fields aren't initialized yet. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Parent {

  public Parent () {
    doSomething();  // Noncompliant
  }

  public void doSomething () {  // not final; can be overridden
    ...
  }
}

public class Child extends Parent {

  private String foo;

  public Child(String foo) {
    super(); // leads to call doSomething() in Parent constructor which triggers a NullPointerException as foo has not yet been initialized
    this.foo = foo;
  }

  public void doSomething () {
    System.out.println(this.foo.length());
  }

}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/MYYbAQ">CERT, MET05-J.</a> - Ensure that constructors do not call overridable methods
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/TQBi">CERT, OOP50-CPP.</a> - Do not invoke virtual functions from constructors or
  destructors </li>
</ul>Z
CODE_SMELL
è
squid:S2676ˇ
squidS2676SNeither "Math.abs" nor negation should be used on numbers that could be "MIN_VALUE""MINOR*java:á<p>It is possible for a call to <code>hashCode</code> to return <code>Integer.MIN_VALUE</code>. Take the absolute value of such a hashcode and you'll
still have a negative number. Since your code is likely to assume that it's a positive value instead, your results will be unreliable.</p>
<p>Similarly, <code>Integer.MIN_VALUE</code> could be returned from <code>Random.nextInt()</code> or any object's <code>compareTo</code> method, and
<code>Long.MIN_VALUE</code> could be returned from <code>Random.nextLong()</code>. Calling <code>Math.abs</code> on values returned from these methods
is similarly ill-advised.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething(String str) {
  if (Math.abs(str.hashCode()) &gt; 0) { // Noncompliant
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(String str) {
  if (str.hashCode() != 0) {
    // ...
  }
}
</pre>ZBUG
è	
squid:S2677ˇ
squidS26772"read" and "readLine" return values should be used"MAJOR*java:®<p>When a method is called that returns data read from some data source, that data should be stored rather than thrown away. Any other course of
action is surely a bug.</p>
<p>This rule raises an issue when the return value of any of the following is ignored or merely null-checked: <code>BufferedReader.readLine()</code>,
<code>Reader.read()</code>, and these methods in any child classes.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomethingWithFile(String fileName) {
  BufferedReader buffReader = null;
  try {
    buffReader = new BufferedReader(new FileReader(fileName));
    while (buffReader.readLine() != null) { // Noncompliant
      // ...
    }
  } catch (IOException e) {
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomethingWithFile(String fileName) {
  BufferedReader buffReader = null;
  try {
    buffReader = new BufferedReader(new FileReader(fileName));
    String line = null;
    while ((line = buffReader.readLine()) != null) {
      // ...
    }
  } catch (IOException e) {
    // ...
  }
}
</pre>ZBUG
«
squid:S3400∑
squidS3400#Methods should not return constants"MINOR*java:Ë<p>There's no point in forcing the overhead of a method call for a method that always returns the same constant value. Even worse, the fact that a
method call must be made will likely mislead developers who call the method thinking that something more is done. Declare a constant instead. </p>
<p>This rule raises an issue if on methods that contain only one statement: the <code>return</code> of a constant value. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public int getBestNumber() {
  return 12;  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public static int bestNumber = 12;
</pre>
<h2>Exceptions</h2>
<p>Methods with annotations, such as <code>@Override</code> and Spring's <code>@RequestMapping</code>, are ignored.</p>Z
CODE_SMELL
◊
squid:S2674«
squidS26747The value returned from a stream read should be checked"MINOR*java:Î<p>You cannot assume that any given stream reading call will fill the <code>byte[]</code> passed in to the method. Instead, you must check the value
returned by the read method to see how many bytes were read. Fail to do so, and you introduce bug that is both harmful and difficult to reproduce.</p>
<p>Similarly, you cannot assume that <code>InputStream.skip</code> will actually skip the requested number of bytes, but must check the value returned
from the method.</p>
<p>This rule raises an issue when an <code>InputStream.read</code> method that accepts a <code>byte[]</code> is called, but the return value is not
checked, and when the return value of <code>InputStream.skip</code> is not checked. The rule also applies to <code>InputStream</code> child
classes.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething(String fileName) {
  try {
    InputStream is = new InputStream(file);
    byte [] buffer = new byte[1000];
    is.read(buffer);  // Noncompliant
    // ...
  } catch (IOException e) { ... }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(String fileName) {
  try {
    InputStream is = new InputStream(file);
    byte [] buffer = new byte[1000];
    int count = 0;
    while (count = is.read(buffer) &gt; 0) {
      // ...
    }
  } catch (IOException e) { ... }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/XACSAQ">CERT, FIO10-J.</a> - Ensure the array is filled when using read() to fill an
  array </li>
</ul>ZBUG
Ï
squid:S1223‹
squidS1223LNon-constructor methods should not have the same name as the enclosing class"MAJOR*java:‰<p>Having a class and some of its methods sharing the same name is misleading, and leaves others to wonder whether it was done that way on purpose, or
was the methods supposed to be a constructor.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo {
   public Foo() {...}
   public void Foo(String label) {...}  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo {
   public Foo() {...}
   public void foo(String label) {...}  // Compliant
}
</pre>Z
CODE_SMELL
§
squid:S2675î
squidS2675)"readObject" should not be "synchronized""MAJOR*java:ø<p>A <code>readObject</code> method is written when a <code>Serializable</code> object needs special handling to be rehydrated from file. It should be
the case that the object being created by <code>readObject</code> is only visible to the thread that invoked the method, and the
<code>synchronized</code> keyword is not needed, and using <code>synchronized</code> anyway is just confusing. If this is not the case, the method
should be refactored to make it the case.</p>
<h2>Noncompliant Code Example</h2>
<pre>
private synchronized void readObject(java.io.ObjectInputStream in)
     throws IOException, ClassNotFoundException { // Noncompliant
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
private void readObject(java.io.ObjectInputStream in)
     throws IOException, ClassNotFoundException { // Compliant
  //...
}
</pre>Z
CODE_SMELL
°
squid:S1221ë
squidS12211Methods should not be named "hashcode" or "equal""MAJOR*java:ª<p>Naming a method <code>hashcode()</code> or <code>equal</code> is either:</p>
<ul>
  <li> A bug in the form of a typo. Overriding <code>Object.hashCode()</code> (note the camelCasing) or <code>Object.equals</code> (note the 's' on
  the end) was meant, and the application does not behave as expected. </li>
  <li> Done on purpose. The name however will confuse every other developer, who may not notice the naming difference, or who will think it is a bug.
  </li>
</ul>
<p>In both cases, the method should be renamed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int hashcode() { /* ... */ }  // Noncompliant

public boolean equal(Object obj) { /* ... */ }  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
@Override
public int hashCode() { /* ... */ }

public boolean equals(Object obj) { /* ... */ }
</pre>ZBUG
û
squid:S1220é
squidS1220.The default unnamed package should not be used"MINOR*java:¥<p>According to the Java Language Specification:</p>
<blockquote>
  <p>Unnamed packages are provided by the Java platform principally for convenience when developing small or temporary applications or when just
  beginning development.</p>
</blockquote>
<p>To enforce this best practice, classes located in default package can no longer be accessed from named ones since Java 1.4.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass { /* ... */ }
</pre>
<h2>Compliant Solution</h2>
<pre>
package org.example;

public class MyClass{ /* ... */ }
</pre>Z
CODE_SMELL

squid:S2438‡
squidS2438;"Threads" should not be used where "Runnables" are expected"MAJOR*java:˘<p>While it is technically correct to use a <code>Thread</code> where a <code>Runnable</code> is called for, the semantics of the two objects are
different, and mixing them is a bad practice that will likely lead to headaches in the future.</p>
<p>The crux of the issue is that <code>Thread</code> is a larger concept than <code>Runnable</code>. A <code>Runnable</code> is an object whose
running should be managed. A <code>Thread</code> expects to manage the running of itself or other <code>Runnables</code>. </p>
<h2>Noncompliant Code Example</h2>
<pre>
	public static void main(String[] args) {
		Thread r =new Thread() {
			int p;
			@Override
			public void run() {
				while(true)
					System.out.println("a");
			}
		};
		new Thread(r).start();  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
	public static void main(String[] args) {
		Runnable r =new Runnable() {
			int p;
			@Override
			public void run() {
				while(true)
					System.out.println("a");
			}
		};
		new Thread(r).start();
</pre>Z
CODE_SMELL
’
squid:S1228≈
squidS12287Packages should have a javadoc file 'package-info.java'"MINOR*java:‚<p>Each package in a Java project should include a <code>package-info.java</code> file. The purpose of this file is to document the Java package using
javadoc and declare package annotations.</p>
<h2>Compliant Solution</h2>
<pre>
/**
* This package has non null parameters and is documented.
**/
@ParametersAreNonnullByDefault
package org.foo.bar;
</pre>Z
CODE_SMELL
˚
squid:S2437Î
squidS2437,Silly bit operations should not be performed"MAJOR*java:ö<p>Certain bit operations are just silly and should not be performed because their results are predictable.</p>
<p>Specifically, using <code>&amp; -1</code> with any value will always result in the original value, as will <code>anyValue ^ 0</code> and
<code>anyValue | 0</code>.</p>ZBUG
∫
squid:S1226™
squidS1226SMethod parameters, caught exceptions and foreach variables should not be reassigned"MINOR*java:≤<p>While it is technically correct to assign to parameters from within method bodies, it is typically done in error, with the intent to assign a
parameter value to a field of the same name, (and <code>this</code> was forgotten). </p>
<p>If it is done on purpose, a better course would be to use temporary variables to store intermediate results. Allowing parameters to be assigned to
also reduces code readability because developers won't be able to tell whether the original parameter or some temporary variable is being accessed
without going through the whole method. Moreover, some developers might also expect assignments of method parameters to be visible to callers, which
is not the case, and this lack of visibility could confuse them. Instead, all parameters, caught exceptions, and foreach parameters should be treated
as <code>final</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass {
  public String name;

  public MyClass(String name) {
    name = name;                    // Noncompliant - useless identity assignment
  }

  public int add(int a, int b) {
    a = a + b;                      // Noncompliant

    /* additional logic */

    return a;                       // Seems like the parameter is returned as is, what is the point?
  }

  public static void main(String[] args) {
    MyClass foo = new MyClass();
    int a = 40;
    int b = 2;
    foo.add(a, b);                  // Variable "a" will still hold 40 after this call
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {
  public String name;

  public MyClass(String name) {
    this.name = name;               // Compliant
  }

  public int add(int a, int b) {
    return a + b;                   // Compliant
  }

  public static void main(String[] args) {
    MyClass foo = new MyClass();
    int a = 40;
    int b = 2;
    foo.add(a, b);
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2012, 17.8 - A function parameter should not be modified </li>
</ul>ZBUG
ú
 squid:ForLoopCounterChangedCheck˜
squidForLoopCounterChangedCheck."for" loop stop conditions should be invariant"MAJOR*java2S127:Ç<p>A <code>for</code> loop stop condition should test the loop counter against an invariant value (i.e. one that is true at both the beginning and
ending of every loop iteration). Ideally, this means that the stop condition is set to a local variable just before the loop begins. </p>
<p>Stop conditions that are not invariant are slightly less efficient, as well as being difficult to understand and maintain, and likely lead to the
introduction of errors in the future.</p>
<p>This rule tracks three types of non-invariant stop conditions:</p>
<ul>
  <li> When the loop counters are updated in the body of the <code>for</code> loop </li>
  <li> When the stop condition depend upon a method call </li>
  <li> When the stop condition depends on an object property, since such properties could change during the execution of the loop. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
for (int i = 0; i &lt; 10; i++) {
  ...
  i = i - 1; // Noncompliant; counter updated in the body of the loop
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
for (int i = 0; i &lt; 10; i++) {...}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 13.6 - Numeric variables being used within a <em>for</em> loop for iteration counting shall not be modified in the body of the
  loop. </li>
  <li> MISRA C++:2008, 6-5-3 - The <em>loop-counter</em> shall not be modified within <em>condition</em> or <em>statement</em>. </li>
</ul>Z
CODE_SMELL
™
"squid:ObjectFinalizeOverridenCheckÉ
squidObjectFinalizeOverridenCheck4The Object.finalize() method should not be overriden"MAJOR*java2S1113:å<p>The <code>Object.finalize()</code> method is called on an object by the garbage collector when it determines that there are no more references to
the object. But there is absolutely no warranty that this method will be called AS SOON AS the last references to the object are removed. It can be
few microseconds to few minutes later. So when system resources need to be disposed by an object, it's better to not rely on this asynchronous
mechanism to dispose them.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {
  ...
  protected void finalize() {
    releaseSomeResources();    // Noncompliant
  }
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/H4cbAQ">CERT, MET12-J.</a> - Do not use finalizers </li>
</ul>ZBUG
ª
squid:ArchitecturalConstraintô
squidArchitecturalConstraint+Track breaches of architectural constraints"MAJOR*java2S1212:ß<p>A source code comply to an architectural model when it fully adheres to a set of architectural constraints. A constraint allows to deny references
between classes by pattern.</p>
<p>You can for instance use this rule to :</p>
<ul>
  <li> forbid access to <code>**.web.**</code> from <code>**.dao.**</code> classes </li>
  <li> forbid access to <code>java.util.Vector</code>, <code>java.util.Hashtable</code> and <code>java.util.Enumeration</code> from any classes </li>
  <li> forbid access to <code>java.sql.**</code> from <code>**.ui.**</code> and <code>**.web.**</code> classes </li>
</ul>
<h2>Deprecated</h2>
<p>This rule is deprecated, and will eventually be removed.</p>@Z
CODE_SMELL
•
squid:S2885ï
squidS2885+Non-thread-safe fields should not be static"MAJOR*java:≈<p>Not all classes in the standard Java library were written to be thread-safe. Using them in a multi-threaded manner is highly likely to cause data
problems or exceptions at runtime.</p>
<p>This rule raises an issue when an instance of <code>Calendar</code>, <code>DateFormat</code>, <code>javax.xml.xpath.XPath</code>, or
<code>javax.xml.validation.SchemaFactory</code> is marked <code>static</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {
  static private SimpleDateFormat format = new SimpleDateFormat("HH-mm-ss");  // Noncompliant
  static private Calendar calendar = Calendar.getInstance();  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {
  private SimpleDateFormat format = new SimpleDateFormat("HH-mm-ss");
  private Calendar calendar = Calendar.getInstance();
</pre>ZBUG
Œ
squid:S1313æ
squidS1313$IP addresses should not be hardcoded"MINOR*java:Î<p>Hardcoding an IP address into source code is a bad idea for several reasons:</p>
<ul>
  <li> a recompile is required if the address changes </li>
  <li> it forces the same address to be used in every environment (dev, sys, qa, prod) </li>
  <li> it places the responsibility of setting the value to use in production on the shoulders of the developer </li>
  <li> it allows attackers to decompile the code and thereby discover a potentially sensitive address </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
String ip = "127.0.0.1";
Socket socket = new Socket(ip, 6667);
</pre>
<h2>Compliant Solution</h2>
<pre>
String ip = System.getProperty("myapplication.ip");
Socket socket = new Socket(ip, 6667);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/qQCHAQ">CERT, MSC03-J.</a> - Never hard code sensitive information </li>
</ul>ZVULNERABILITY
÷
squid:S2886∆
squidS28863Getters and setters should be synchronized in pairs"MAJOR*java:Ó
<p>When one part of a getter/setter pair is <code>synchronized</code> the other part should be too. Failure to synchronize both sides of a pair may
result in inconsistent behavior at runtime as callers access an inconsistent method state.</p>
<p>This rule raises an issue when either the method or the contents of one method in a getter/setter pair are synchrnoized but the other is not.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Person {
  String name;
  int age;

  public synchronized void setName(String name) {
    this.name = name;
  }

  public String getName() {  // Noncompliant
    return this.name;
  }

  public void setAge(int age) {  // Noncompliant
    this.age = age;
  }

  public int getAge() {
    synchronized (this) {
      return this.age;
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Person {
  String name;
  int age;

  public synchronized void setName(String name) {
    this.name = name;
  }

  public synchronized String getName() {
    return this.name;
  }

  public void setAge(int age) {
    synchronized (this) {
      this.age = age;
   }
  }

  public int getAge() {
    synchronized (this) {
      return this.age;
    }
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/I4BoAg">CERT, VNA01-J.</a> - Ensure visibility of shared references to immutable
  objects </li>
</ul>ZBUG
Œ
squid:S1312æ
squidS1312MLoggers should be "private static final" and should share a naming convention"MINOR*java:≈<p>Loggers should be:</p>
<ul>
  <li> <code>private</code>: not accessible outside of their parent classes. If another class needs to log something, it should instantiate its own
  logger. </li>
  <li> <code>static</code>: not dependent on an instance of a class (an object). When logging something, contextual information can of course be
  provided in the messages but the logger should be created at class level to prevent creating a logger along with each object. </li>
  <li> <code>final</code>: created once and only once per class. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<p>With a default regular expression of <code>LOG(?:GER)?</code>:</p>
<pre>
public Logger logger = LoggerFactory.getLogger(Foo.class);  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
private static final Logger LOGGER = LoggerFactory.getLogger(Foo.class);
</pre>
<h2>Exceptions</h2>
<p>Variables of type <code>org.apache.maven.plugin.logging.Log</code> are ignored.</p>Z
CODE_SMELL
ˆ
squid:S1310Ê
squidS1310*Track uses of "NOPMD" suppression comments"MINOR*java:ê<p>This rule allows you to track the use of the PMD suppression comment mechanism. </p>
<h2>Noncompliant Code Example</h2>
<pre>
// NOPMD
</pre>Z
CODE_SMELL
˜

squid:S1319Á

squidS1319ÇDeclarations should use Java collection interfaces such as "List" rather than specific implementation classes such as "LinkedList""MINOR*java:∏	<p>The purpose of the Java Collections API is to provide a well defined hierarchy of interfaces in order to hide implementation details.</p>
<p>Implementing classes must be used to instantiate new collections, but the result of an instantiation should ideally be stored in a variable whose
type is a Java Collection interface.</p>
<p>This rule raises an issue when an implementation class:</p>
<ul>
  <li> is returned from a <code>public</code> method. </li>
  <li> is accepted as an argument to a <code>public</code> method. </li>
  <li> is exposed as a <code>public</code> member. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Employees {
  private HashSet&lt;Employee&gt; employees = new HashSet&lt;Employee&gt;();  // Noncompliant - "employees" should have type "Set" rather than "HashSet"

  public HashSet&lt;Employee&gt; getEmployees() {                       // Noncompliant
    return employees;
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Employees {
  private Set&lt;Employee&gt; employees = new HashSet&lt;Employee&gt;();      // Compliant

  public Set&lt;Employee&gt; getEmployees() {                           // Compliant
    return employees;
  }
}
</pre>Z
CODE_SMELL
„
squid:S1317”
squidS1317N"StringBuilder" and "StringBuffer" should not be instantiated with a character"MAJOR*java:‡<p>Instantiating a <code>StringBuilder</code> or a <code>StringBuffer</code> with a character is misleading because most Java developers would expect
the character to be the initial value of the <code>StringBuffer</code>. </p>
<p>What actually happens is that the int representation of the character is used to determine the initial size of the <code>StringBuffer</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
StringBuffer foo = new StringBuffer('x');   //equivalent to StringBuffer foo = new StringBuffer(120);
</pre>
<h2>Compliant Solution</h2>
<pre>
StringBuffer foo = new StringBuffer("x");
</pre>ZBUG
è
squid:S1315ˇ
squidS13153Track uses of "CHECKSTYLE:OFF" suppression comments"MINOR*java:†<p>This rule allows you to track the use of the Checkstyle suppression comment mechanism. </p>
<h2>Noncompliant Code Example</h2>
<pre>
// CHECKSTYLE:OFF
</pre>Z
CODE_SMELL
≤	
squid:S1314¢	
squidS1314Octal values should not be used"BLOCKER*java:’<p>Integer literals starting with a zero are octal rather than decimal values. While using octal values is fully supported, most developers do not
have experience with them. They may not recognize octal values as such, mistaking them instead for decimal values.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int myNumber = 010;   // Noncompliant. myNumber will hold 8, not 10 - was this really expected?
</pre>
<h2>Compliant Solution</h2>
<pre>
int myNumber = 8;
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 7.1 - Octal constants (other than zero) and octal escape sequences shall not be used. </li>
  <li> MISRA C++:2008, 2-13-2 - Octal constants (other than zero) and octal escape sequences (other than "\0") shall not be used </li>
  <li> MISRA C:2012, 7.1 - Octal constants shall not be used </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/_QC7AQ">CERT, DCL18-C.</a> - Do not begin integer constants with 0 when specifying a
  decimal value </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/hYClBg">CERT, DCL50-J.</a> - Use visually distinct identifiers </li>
</ul>Z
CODE_SMELL
¢
squid:S1444í
squidS1444)"public static" fields should be constant"MINOR*java:∫<p>There is no good reason to declare a field "public" and "static" without also declaring it "final". Most of the time this is a kludge to share a
state among several objects. But with this approach, any object can do whatever it wants with the shared state, such as setting it to
<code>null</code>. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Greeter {
  public static Foo foo = new Foo();
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Greeter {
  public static final Foo FOO = new Foo();
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/500.html">MITRE, CWE-500</a> - Public Static Field Not Marked Final </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/QQBqAQ">CERT OBJ10-J.</a> - Do not use public static nonfinal fields </li>
</ul>ZVULNERABILITY
§

squid:S1201î

squidS1201<Methods named "equals" should override Object.equals(Object)"MAJOR*java:≥	<p>"equals" as a method name should be used exclusively to override <code>Object.equals(Object)</code> to prevent any confusion.</p>
<p>It is tempting to overload the method to take a specific class instead of <code>Object</code> as parameter, to save the class comparison check.
However, this will not work as expected.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass {
  private int foo = 1;

  public boolean equals(MyClass o) {                    // Noncompliant - "equals" method which does not override Object.equals(Object)
    return o != null &amp;&amp; o.foo == this.foo;
  }

  public static void main(String[] args) {
    MyClass o1 = new MyClass();
    Object o2 = new MyClass();
    System.out.println(o1.equals(o2));                  // Will display "false" because "o2" is of type "Object" and not "MyClass"
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {
  private int foo = 1;

  @Override
  public boolean equals(Object o) {                     // Compliant - overrides Object.equals(Object)
    if (o == null || !(o instanceof MyClass)) {
      return false;
    }

    MyClass other = (MyClass)o;
    return this.foo == other.foo;
  }

  /* ... */
}
</pre>ZBUG
¢

squid:S2653í

squidS26530Web applications should not have a "main" method"CRITICAL*java:∞	<p>There is no reason to have a <code>main</code> method in a web application. It may have been useful for debugging during application development,
but such a method should never make it into production. Having a <code>main</code> method in a web application opens a door to the application logic
that an attacker may never be able to reach (but watch out if one does!), but it is a sloppy practice and indicates that other problems may be
present.</p>
<p>This rule raises an issue when a <code>main</code> method is found in a servlet or an EJB.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyServlet extends HttpServlet {
  public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    if (userIsAuthorized(req)) {
      updatePrices(req);
    }
  }

  public static void main(String[] args) { // Noncompliant
    updatePrices(req);
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/489.html">MITRE, CWE-489</a> - Leftover Debug Code </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/VoB8Bw">CERT, ENV06-J.</a> - Production code must not contain debugging entry points
  </li>
</ul>ZVULNERABILITY
Ò
squid:S1200·
squidS1200YClasses should not be coupled to too many other classes (Single Responsibility Principle)"MAJOR*java:‹
<p>According to the Single Responsibility Principle, introduced by Robert C. Martin in his book "Principles of Object Oriented Design", a class should
have only one responsibility:</p>
<blockquote>
  <p>If a class has more than one responsibility, then the responsibilities become coupled.</p>
  <p>Changes to one responsibility may impair or inhibit the class' ability to meet the others.</p>
  <p>This kind of coupling leads to fragile designs that break in unexpected ways when changed.</p>
</blockquote>
<p>Classes which rely on many other classes tend to aggregate too many responsibilities and should be split into several smaller ones.</p>
<p>Nested classes dependencies are not counted as dependencies of the outer class.</p>
<h2>Noncompliant Code Example</h2>
<p>With a threshold of 5:</p>
<pre>
class Foo {                        // Noncompliant - Foo depends on too many classes: T1, T2, T3, T4, T5, T6 and T7
  T1 a1;                           // Foo is coupled to T1
  T2 a2;                           // Foo is coupled to T2
  T3 a3;                           // Foo is coupled to T3

  public T4 compute(T5 a, T6 b) {  // Foo is coupled to T4, T5 and T6
    T7 result = a.getResult(b);    // Foo is coupled to T7
    return result;
  }

  public static class Bar {        // Compliant - Bar depends on 2 classes: T8 and T9
    T8 a8;
    T9 a9;
  }
}
</pre>Z
CODE_SMELL
‚	
squid:S1449“	
squidS1449*Locale should be used in String operations"MINOR*java:É	<p>Failure to specify a locale when calling the methods <code>toLowerCase()</code> or <code>toUpperCase()</code> on <code>String</code> objects means
the system default encoding will be used, possibly creating problems with international characters. For instance with the Turkish language, when
converting the small letter 'i' to upper case, the result is capital letter 'I' with a dot over it.</p>
<p>Case conversion without a locale may work fine in its "home" environment, but break in ways that are extremely difficult to diagnose for customers
who use different encodings. Such bugs can be nearly, if not completely, impossible to reproduce when it's time to fix them. For locale-sensitive
strings, the correct locale should always be used, but <code>Locale.ENGLISH</code> can be used for case-insensitive ones.</p>
<h2>Noncompliant Code Example</h2>
<pre>
myString.toLowerCase()
</pre>
<h2>Compliant Solution</h2>
<pre>
myString.toLowerCase(Locale.TR)
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/EwAiAg">CERT, STR02-J.</a> - Specify an appropriate locale when comparing
  locale-dependent data </li>
</ul>ZBUG
¡
squid:S2658±
squidS2658(Classes should not be loaded dynamically"CRITICAL*java:◊<p>Dynamically loaded classes could contain malicious code executed by a static class initializer. I.E. you wouldn't even have to instantiate or
explicitly invoke methods on such classes to be vulnerable to an attack.</p>
<p>This rule raises an issue for each use of dynamic class loading.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String className = System.getProperty("messageClassName");
Class clazz = Class.forName(className);  // Noncompliant
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/545.html">MITRE, CWE-545</a> - Use of Dynamic Class Loading </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A1-Injection">OWASP Top 10 2013 Category A1</a> - Injection </li>
</ul>ZVULNERABILITY
˘
squid:S1448È
squidS1448(Classes should not have too many methods"MAJOR*java:ï<p>A class that grows too much tends to aggregate too many responsibilities and inevitably becomes harder to understand and therefore to maintain.
Above a specific threshold, it is strongly advised to refactor the class into smaller ones which focus on well defined topics.</p>Z
CODE_SMELL
À
squid:S1206ª
squidS1206C"equals(Object obj)" and "hashCode()" should be overridden in pairs"MINOR*java:”<p>According to the Java Language Specification, there is a contract between <code>equals(Object)</code> and <code>hashCode()</code>:</p>
<blockquote>
  <p>If two objects are equal according to the <code>equals(Object)</code> method, then calling the <code>hashCode</code> method on each of the two
  objects must produce the same integer result. </p>
  <p>It is not required that if two objects are unequal according to the <code>equals(java.lang.Object)</code> method, then calling the
  <code>hashCode</code> method on each of the two objects must produce distinct integer results.</p>
  <p>However, the programmer should be aware that producing distinct integer results for unequal objects may improve the performance of
  hashtables.</p>
</blockquote>
<p>In order to comply with this contract, those methods should be either both inherited, or both overridden.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass {    // Noncompliant - should also override "hashCode()"

  @Override
  public boolean equals(Object obj) {
    /* ... */
  }

}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {    // Compliant

  @Override
  public boolean equals(Object obj) {
    /* ... */
  }

  @Override
  public int hashCode() {
    /* ... */
  }

}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/581.html">MITRE, CWE-581</a> - Object Model Violation: Just One of Equals and Hashcode Defined
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/EYYbAQ">CERT, MET09-J.</a> - Classes that define an equals() method must also define a
  hashCode() method </li>
</ul>ZBUG
∑
squid:S1940ß
squidS1940%Boolean checks should not be inverted"MINOR*java:÷<p>It is needlessly complex to invert the result of a boolean comparison. The opposite comparison should be made instead.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if ( !(a == 2)) { ...}  // Noncompliant
boolean b = !(i &lt; 10);  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
if (a != 2) { ...}
boolean b = (i &gt;= 10);
</pre>Z
CODE_SMELL
¶
#squid:RightCurlyBraceStartLineCheck˛
squidRightCurlyBraceStartLineCheck@A close curly brace should be located at the beginning of a line"MINOR*java2S1109:Û<p>Shared coding conventions make it possible for a team to efficiently collaborate. This rule makes it mandatory to place a close curly brace at the
beginning of a line.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if(condition) {
  doSomething();}
</pre>
<h2>Compliant Solution</h2>
<pre>
if(condition) {
  doSomething();
}
</pre>
<h2>Exceptions</h2>
<p>When blocks are inlined (open and close curly braces on the same line), no issue is triggered. </p>
<pre>
if(condition) {doSomething();}
</pre>Z
CODE_SMELL
è
squid:S1948ˇ
squidS1948KFields in a "Serializable" class should either be transient or serializable"CRITICAL*java:å<p>Fields in a <code>Serializable</code> class must themselves be either <code>Serializable</code> or <code>transient</code> even if the class is
never explicitly serialized or deserialized. That's because under load, most J2EE application frameworks flush objects to disk, and an allegedly
<code>Serializable</code> object with non-transient, non-serializable data members could cause program crashes, and open the door to attackers.</p>
<p>This rule raises an issue on non-<code>Serializable</code> fields, and on collection fields when they are not <code>private</code> (because they
could be assigned non-<code>Serializable</code> values externally), and when they are assigned non-<code>Serializable</code> types within the
class.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Address {
  //...
}

public class Person implements Serializable {
  private static final long serialVersionUID = 1905122041950251207L;

  private String name;
  private Address address;  // Noncompliant; Address isn't serializable
}
</pre>
<h2>Exceptions</h2>
<p>The alternative to making all members <code>serializable</code> or <code>transient</code> is to implement special methods which take on the
responsibility of properly serializing and de-serializing the object. This rule ignores classes which implement the following methods:</p>
<pre>
 private void writeObject(java.io.ObjectOutputStream out)
     throws IOException
 private void readObject(java.io.ObjectInputStream in)
     throws IOException, ClassNotFoundException;
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/594.html">MITRE, CWE-594</a> - Saving Unserializable Objects to Disk </li>
  <li> <a href="http://docs.oracle.com/javase/6/docs/api/java/io/Serializable.html">Oracle Java 6, Serializable</a> </li>
  <li> <a href="http://docs.oracle.com/javase/7/docs/api/java/io/Serializable.html">Oracle Java 7, Serializable</a> </li>
</ul>ZBUG
…
squid:S2912π
squidS2912,"indexOf" checks should use a start position"MINOR*java:·<p>One thing that makes good code good is the clarity with which it conveys the intent of the original programmer to maintainers, and the proper
choice of <code>indexOf</code> methods can help move code from confusing to clear.</p>
<p>If you need to see whether a substring is located beyond a certain point in a string, you can test the <code>indexOf</code> the substring versus
the target point, or you can use the version of <code>indexOf</code> which takes a starting point argument. The latter is arguably clearer because the
result is tested against -1, which is an easily recognizable "not found" indicator.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String name = "ismael";

if (name.indexOf("ae") &gt; 2) { // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
String name = "ismael";

if (name.indexOf("ae", 2) &gt; -1) {
  // ...
}
</pre>Z
CODE_SMELL
ù
squid:S1943ç
squidS1943OClasses and methods that rely on the default system encoding should not be used"MINOR*java:ô<p>Using classes and methods that rely on the default system encoding can result in code that works fine in its "home" environment. But that code may
break for customers who use different encodings in ways that are extremely difficult to diagnose and nearly, if not completely, impossible to
reproduce when it's time to fix them.</p>
<p>This rule detects uses of the following classes and methods:</p>
<ul>
  <li> <code>FileReader</code> </li>
  <li> <code>FileWriter</code> </li>
  <li> String constructors with a <code>byte[]</code> argument but no <code>Charset</code> argument
    <ul>
      <li> <code>String(byte[] bytes)</code> </li>
      <li> <code>String(byte[] bytes, int offset, int length)</code> </li>
    </ul> </li>
  <li> <code>String.getBytes()</code> </li>
  <li> <code>String.getBytes(int srcBegin, int srcEnd, byte[] dst, int dstBegin)</code> </li>
  <li> <code>InputStreamReader(InputStream in)</code> </li>
  <li> <code>OutputStreamWriter(OutputStream out)</code> </li>
  <li> <code>ByteArrayOutputStream.toString()</code> </li>
  <li> Some <code>Formatter</code> constructors
    <ul>
      <li> <code>Formatter(String fileName)</code> </li>
      <li> <code>Formatter(File file)</code> </li>
      <li> <code>Formatter(OutputStream os)</code> </li>
    </ul> </li>
  <li> Some <code>Scanner</code> constructors
    <ul>
      <li> <code>Scanner(File source)</code> </li>
      <li> <code>Scanner(Path source)</code> </li>
      <li> <code>Scanner(InputStream source)</code> </li>
    </ul> </li>
  <li> Some <code>PrintStream</code> constructors
    <ul>
      <li> <code>PrintStream(File file)</code> </li>
      <li> <code>PrintStream(OutputStream out)</code> </li>
      <li> <code>PrintStream(OutputStream out, boolean autoFlush)</code> </li>
      <li> <code>PrintStream(String fileName)</code> </li>
    </ul> </li>
  <li> Some <code>PrintWriter</code> constructors
    <ul>
      <li> <code>PrintWriter(File file)</code> </li>
      <li> <code>PrintWriter(OutputStream out)</code> </li>
      <li> <code>PrintWriter(OutputStream out, boolean autoFlush)</code> </li>
      <li> <code>PrintWriter(String fileName)</code> </li>
    </ul> </li>
  <li> <code>IOUtils</code> methods which accept an encoding argument when that argument is null, and overloads of those methods that omit the
  encoding argument </li>
</ul>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/FoL5AQ">CERT, STR04-J.</a> - Use compatible character encodings when communicating
  string data between JVMs </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/JgAWCQ">CERT, STR50-J.</a> - Use the appropriate method for counting characters in a
  string </li>
</ul>ZBUG
Ç
squid:S1942Ú
squidS1942!Simple class names should be used"MINOR*java:•<p>Java's <code>import</code> mechanism allows the use of simple class names. Therefore, using a class' fully qualified name in a file that
<code>import</code>s the class is redundant and confusing.</p>
<h2>Noncompliant Code Example</h2>
<pre>
import java.util.List;
import java.sql.Timestamp;

//...

java.util.List&lt;String&gt; myList;  // Noncompliant
java.sql.Timestamp tStamp; // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
import java.util.List;
import java.sql.Timestamp;

//...

List&lt;String&gt; myList;
Timestamp tStamp;
</pre>Z
CODE_SMELL
æ	
squid:S1700Æ	
squidS1700=A field should not duplicate the name of its containing class"MAJOR*java:≈<p>It's confusing to have a class member with the same name (case differences aside) as its enclosing class. This is particularly so when you consider
the common practice of naming a class instance for the class itself.</p>
<p>Best practice dictates that any field or member with the same name as the enclosing class be renamed to be more descriptive of the particular
aspect of the class it represents or holds.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo {
  private String foo;

  public String getFoo() { }
}

Foo foo = new Foo();
foo.getFoo() // what does this return?
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Foo {
  private String name;

  public String getName() { }
}

//...

Foo foo = new Foo();
foo.getName()

</pre>
<h2>Exceptions</h2>
<p>When the type of the field is the containing class and that field is static, no issue is raised to allow singletons named like the type. </p>
<pre>
public class Foo {
  ...
  private static Foo foo;
  public Foo getInstance() {
    if(foo==null) {
      foo = new Foo();
    }
    return foo;
  }
  ...
}
</pre>Z
CODE_SMELL
Õ
squid:S1820Ω
squidS1820'Classes should not have too many fields"MAJOR*java:Í<p>A class that grows too much tends to aggregate too many responsibilities and inevitably becomes harder to understand and therefore to maintain, and
having a lot of fields is an indication that a class has grown too large.</p>
<p>Above a specific threshold, it is strongly advised to refactor the class into smaller ones which focus on well defined topics.</p>Z
CODE_SMELL
∆
squid:S1941∂
squidS19419Variables should not be declared before they are relevant"MINOR*java:—<p>For the sake of clarity, variables should be declared as close to where they're used as possible. This is particularly true when considering
methods that contain early returns and the potential to throw exceptions. In these cases, it is not only pointless, but also confusing to declare a
variable that may never be used because conditions for an early return are met first.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public boolean isConditionMet(int a, int b) {
  int difference = a - b;
  MyClass foo = new MyClass(a);  // Noncompliant; not used before early return

  if (difference &lt; 0) {
    return false;
  }

  // ...

  if (foo.doTheThing()) {
    return true;
  }
  return false;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public boolean isConditionMet(int a, int b) {
  int difference = a - b;

  if (difference &lt; 0) {
    return false;
  }

  // ...

  MyClass foo = new MyClass(a);
  if (foo.doTheThing()) {
    return true;
  }
  return false;
}
</pre>Z
CODE_SMELL
Ò
squid:S1939·
squidS19396Extensions and implementations should not be redundant"MINOR*java:ˇ<p>All classes extend <code>Object</code> implicitly. Doing so explicitly is redundant.</p>
<p>Further, declaring the implementation of an interface <em>and</em> one if its parents is also redundant. If you implement the interface, you also
implicitly implement its parents and there's no need to do so explicitly.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public interface MyFace {
  // ...
}

public interface MyOtherFace extends MyFace {
  // ...
}

public class Foo
    extends Object // Noncompliant
    implements MyFace, MyOtherFace {  // Noncompliant
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public interface MyFace {
  // ...
}

public interface MyOtherFace extends MyFace {
  // ...
}

public class Foo implements MyOtherFace {
  //...
}
</pre>Z
CODE_SMELL
≠
squid:S1905ù
squidS1905"Redundant casts should not be used"MINOR*java:œ<p>Unnecessary casting expressions make the code harder to read and understand.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void example() {
  for (Foo obj : (List&lt;Foo&gt;) getFoos()) {  // Noncompliant; cast unnecessary because List&lt;Foo&gt; is what's returned
    //...
  }
}

public List&lt;Foo&gt; getFoos() {
  return this.foos;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void example() {
  for (Foo obj : getFoos()) {
    //...
  }
}

public List&lt;Foo&gt; getFoos() {
  return this.foos;
}
</pre>
<h2>Exceptions</h2>
<p>Casting may be required to distinguish the method to call in the case of overloading:</p>
<pre>
class A {}
class B extends A{}
class C {
  void fun(A a){}
  void fun(B b){}

  void foo() {
    B b = new B();
    fun(b);
    fun((A) b); //call the first method so cast is not redundant.
  }

}
</pre>Z
CODE_SMELL
≤	
-squid:RightCurlyBraceSameLineAsNextBlockCheckÄ	
squid'RightCurlyBraceSameLineAsNextBlockCheckhClose curly brace and the next "else", "catch" and "finally" keywords should be located on the same line"MINOR*java2S1107:√<p>Shared coding conventions make it possible for a team to collaborate efficiently.</p>
<p>This rule makes it mandatory to place closing curly braces on the same line as the next <code>else</code>, <code>catch</code> or
<code>finally</code> keywords.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void myMethod() {
  if(something) {
    executeTask();
  } else if (somethingElse) {
    doSomethingElse();
  }
  else {                               // Noncompliant
     generateError();
  }

  try {
    generateOrder();
  } catch (Exception e) {
    log(e);
  }
  finally {                            // Noncompliant
    closeConnection();
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void myMethod() {
  if(something) {
    executeTask();
  } else if (somethingElse) {
    doSomethingElse();
  } else {
     generateError();
  }

  try {
    generateOrder();
  } catch (Exception e) {
    log(e);
  } finally {
    closeConnection();
  }
}
</pre>Z
CODE_SMELL
’
"squid:CallToFileDeleteOnExitMethodÆ
squidCallToFileDeleteOnExitMethod!"deleteOnExit" should not be used"MINOR*java2S2308: <p>Use of <code>File.deleteOnExit()</code> is not recommended for the following reasons:</p>
<ul>
  <li> The deletion occurs only in the case of a normal JVM shutdown but not when the JVM crashes or is killed. </li>
  <li> For each file handler, the memory associated to the handler is released only at the end of the process. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
File file = new File("file.txt");
file.deleteOnExit();  // Noncompliant
</pre>ZBUG
ı
squid:CallToDeprecatedMethod‘
squidCallToDeprecatedMethod%"@Deprecated" code should not be used"MINOR*java2S1874:Î
<p>Once deprecated, classes, and interfaces, and their members should be avoided, rather than used, inherited or extended. Deprecation is a warning
that the class or interface has been superseded, and will eventually be removed. The deprecation period allows you to make a smooth transition away
from the aging, soon-to-be-retired technology.</p>
<h2>Noncompliant Code Example</h2>
<pre>
/**
 * @deprecated  As of release 1.3, replaced by {@link #Fee}
 */
@Deprecated
public class Fum { ... }

public class Foo {
  /**
   * @deprecated  As of release 1.7, replaced by {@link #doTheThingBetter()}
   */
  @Deprecated
  public void doTheThing() { ... }

  public void doTheThingBetter() { ... }
}

public class Bar extends Foo {
  public void doTheThing() { ... } // Noncompliant; don't override a deprecated method or explicitly mark it as @Deprecated
}

public class Bar extends Fum {  // Noncompliant; Fum is deprecated

  public void myMethod() {
    Foo foo = new Foo();  // okay; the class isn't deprecated
    foo.doTheThing();  // Noncompliant; doTheThing method is deprecated
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/477.html">MITRE, CWE-477</a> - Use of Obsolete Functions </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/KgAVAg">CERT, MET02-J.</a> - Do not use deprecated or obsolete classes or methods </li>
</ul>Z
CODE_SMELL
Å
squid:S1610Ò
squidS1610AAbstract classes without fields should be converted to interfaces"MINOR*java:Ñ<p>With Java 8's "default method" feature, any abstract class without direct or inherited field should be converted into an interface. However, this
change may not be appropriate in libraries or other applications where the class is intended to be used as an API.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public abstract class Car {
  public abstract void start(Environment c);

  public void stop(Environment c) {
    c.freeze(this);
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public interface Car {
  public void start(Environment c);

  public default void stop(Environment c) {
    c.freeze(this);
  }
}
</pre>Z
CODE_SMELL
®
squid:S1850ò
squidS1850M"instanceof" operators that always return "true" or "false" should be removed"MAJOR*java:¶<p><code>instanceof</code> operators that always return <code>true</code> or <code>false</code> are either useless or the result of a misunderstanding
which could lead to unexpected behavior in production.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public boolean isSuitable(Integer param) {
...
  String name = null;

  if (name instanceof String) { // Noncompliant; always false since name is null
    //...
  }

  if(param instanceof Number) {  // Noncompliant; always true unless param is null, because param is an Integer
    doSomething();
  }
...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public boolean isSuitable(Integer param) {
...
  doSomething();
...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/571.html">MITRE, CWE-571</a> - Expression is Always True </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/570.html">MITRE, CWE-570</a> - Expression is Always False </li>
</ul>ZBUG
√
squid:S1858≥
squidS18586"toString()" should never be called on a String object"MINOR*java:ÿ<p>Invoking a method designed to return a string representation of an object which is already a string is a waste of keystrokes. This redundant
construction may be optimized by the compiler, but will be confusing in the meantime.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String message = "hello world";
System.out.println(message.toString()); // Noncompliant;
</pre>
<h2>Compliant Solution</h2>
<pre>
String message = "hello world";
System.out.println(message);
</pre>ZBUG
É
squid:S2701Û
squidS27017Literal boolean values should not be used in assertions"CRITICAL*java:ç<p>There's no reason to use literal boolean values in assertions. Doing so is at best confusing for maintainers, and at worst a bug.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Assert.assertTrue(true);  // Noncompliant
assertThat(true).isTrue(); // Noncompliant
</pre>Z
CODE_SMELL
À
squid:S1611ª
squidS1611\Parentheses should be removed from a single lambda input parameter when its type is inferred"MINOR*java:≥<p>There are two possible syntaxes for a lambda having only one input parameter with an inferred type: with and without parentheses around that single
parameter. The simpler syntax, without parentheses, is more compact and readable than the one with parentheses, and is therefore preferred.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
(x) -&gt; x * 2
</pre>
<h2>Compliant Solution</h2>
<pre>
x -&gt; x * 2
</pre>Z
CODE_SMELL
ô

squid:S1862â

squidS1862BRelated "if/else if" statements should not have the same condition"MAJOR*java:¢	<p>A chain of <code>if</code>/<code>else if</code> statements is evaluated from top to bottom. At most, only one branch will be executed: the first
one with a condition that evaluates to <code>true</code>. </p>
<p>Therefore, duplicating a condition automatically leads to dead code. Usually, this is due to a copy/paste error. At best, it's simply dead code and
at worst, it's a bug that is likely to induce further bugs as the code is maintained, and obviously it could lead to unexpected behavior. </p>
<h2>Noncompliant Code Example</h2>
<pre>
if (param == 1)
  openWindow();
else if (param == 2)
  closeWindow();
else if (param == 1)  // Noncompliant
  moveWindowToTheBackground();
}
</pre>
<h2>Compliant Solution</h2>
<pre>
if (param == 1)
  openWindow();
else if (param == 2)
  closeWindow();
else if (param == 3)
  moveWindowToTheBackground();
}

</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
</ul>ZBUG
»
squid:S1860∏
squidS1860BSynchronization should not be based on Strings or boxed primitives"MAJOR*java:—<p>Objects which are pooled and potentially reused should not be used for synchronization. If they are, it can cause unrelated threads to deadlock
with unhelpful stacktraces. Specifically, <code>String</code> literals, and boxed primitives such as Integers should not be used as lock objects
because they are pooled and reused. The story is even worse for <code>Boolean</code> objects, because there are only two instances of
<code>Boolean</code>, <code>Boolean.TRUE</code> and <code>Boolean.FALSE</code> and every class that uses a Boolean will be referring to one of the
two.</p>
<h2>Noncompliant Code Example</h2>
<pre>
private static final Boolean bLock = Boolean.FALSE;
private static final Integer iLock = Integer.valueOf(0);
private static final String sLock = "LOCK";

public void doSomething() {

  synchronized(bLock) {  // Noncompliant
    // ...
  }
  synchronized(iLock) {  // Noncompliant
    // ...
  }
  synchronized(sLock) {  // Noncompliant
    // ...
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
private static final Object lock1 = new Object();
private static final Object lock2 = new Object();
private static final Object lock3 = new Object();

public void doSomething() {

  synchronized(lock1) {
    // ...
  }
  synchronized(lock2) {
    // ...
  }
  synchronized(lock3) {
    // ...
  }
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/rQGeAQ">CERT, LCK01-J.</a> - Do not synchronize on objects that may be reused </li>
</ul>ZBUG
õ
squid:S2959ã
squidS2959(Unnecessary semicolons should be omitted"MINOR*java:∑<p>Under the reasoning that cleaner code is better code, the semicolon at the end of a try-with-resources construct should be omitted because it can
be omitted.</p>
<h2>Noncompliant Code Example</h2>
<pre>
try (ByteArrayInputStream b = new ByteArrayInputStream(new byte[10]);  // ignored; this one's required
      Reader r = new InputStreamReader(b);)   // Noncompliant
{
   //do stuff
}
</pre>
<h2>Compliant Solution</h2>
<pre>
try (ByteArrayInputStream b = new ByteArrayInputStream(new byte[10]);
      Reader r = new InputStreamReader(b))
{
   //do stuff
}
</pre>Z
CODE_SMELL
ò
squid:S2718à
squidS2718H"DateUtils.truncate" from Apache Commons Lang library should not be used"MAJOR*java:õ<p>The use of the <code>Instant</code> class introduced in Java 8 to truncate a date can be significantly faster than the <code>DateUtils</code> class
from Commons Lang.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public Date trunc(Date date) {
  return DateUtils.truncate(date, Calendar.SECOND);  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public Date trunc(Date date) {
  Instant instant = date.toInstant();
  instant = instant.truncatedTo(ChronoUnit.SECONDS);
  return Date.from(instant);
}
</pre>ZBUG
∂
squid:S1989¶
squidS19894Exceptions should not be thrown from servlet methods"MINOR*java:√<p>Even though the signatures for methods in a servlet include <code>throws IOException, ServletException</code>, it's a bad idea to let such
exceptions be thrown. Failure to catch exceptions in a servlet could leave a system in a vulnerable state, possibly resulting in denial-of-service
attacks, or the exposure of sensitive information because when a servlet throws an exception, the servlet container typically sends debugging
information back to the user. And that information could be very valuable to an attacker. </p>
<p>This rule checks all exceptions in methods named "do*" are explicitly handled in servlet classes.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doGet(HttpServletRequest request, HttpServletResponse response)
  throws IOException, ServletException {
  String ip = request.getRemoteAddr();
  InetAddress addr = InetAddress.getByName(ip); // Noncompliant; getByName(String) throws UnknownHostException
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doGet(HttpServletRequest request, HttpServletResponse response)
  throws IOException, ServletException {
  try {
    String ip = request.getRemoteAddr();
    InetAddress addr = InetAddress.getByName(ip);
    //...
  }
  catch (UnknownHostException uhex) {
    //...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/600.html">MITRE, CWE-600</a> - Uncaught Exception in Servlet </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/s4EVAQ">CERT, ERR01-J.</a> - Do not allow exceptions to expose sensitive information
  </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten Category A6</a> - Sensitive Data Exposure </li>
</ul>ZVULNERABILITY
Ù
squid:HiddenFieldCheckŸ
squidHiddenFieldCheck.Local variables should not shadow class fields"MAJOR*java2S1117:Ì<p>Shadowing fields with a local variable is a bad practice that reduces code readability: it makes it confusing to know whether the field or the
variable is being used.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class Foo {
  public int myField;

  public void doSomething() {
    int myField = 0;
    ...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/2ADEAw">CERT, DCL51-J.</a> - Do not shadow or obscure identifiers in subscopes </li>
</ul>Z
CODE_SMELL
›

squid:S134Œ
squidS134`Control flow statements "if", "for", "while", "switch" and "try" should not be nested too deeply"CRITICAL*java:¿<p>Nested <code>if</code>, <code>for</code>, <code>while</code>, <code>switch</code>, and <code>try</code> statements is a key ingredient for making
what's known as "Spaghetti code".</p>
<p>Such code is hard to read, refactor and therefore maintain.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold of 3:</p>
<pre>
if (condition1) {                  // Compliant - depth = 1
  /* ... */
  if (condition2) {                // Compliant - depth = 2
    /* ... */
    for(int i = 0; i &lt; 10; i++) {  // Compliant - depth = 3, not exceeding the limit
      /* ... */
      if (condition4) {            // Noncompliant - depth = 4
        if (condition5) {          // Depth = 5, exceeding the limit, but issues are only reported on depth = 4
          /* ... */
        }
        return;
      }
    }
  }
}
</pre>Z
CODE_SMELL
Ω
squid:S2924≠
squidS2924JUnit rules should be used"MINOR*java:Á<p>While some <code>TestRule</code> classes have the desired effect without ever being directly referenced by a test, several others do not, and
there's no reason to leave them cluttering up the file if they're not in use.</p>
<p>This rule raises an issue when <code>Test</code> class fields of the following types aren't used by any of the test methods:
<code>TemporaryFolder</code>, and <code>TestName</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class ProjectDefinitionTest {

  @Rule
  public TemporaryFolder temp = new TemporaryFolder();  // Noncompliant

  @Test
  public void shouldSetKey() {
    ProjectDefinition def = ProjectDefinition.create();
    def.setKey("mykey");
    assertThat(def.getKey(), is("mykey"));
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class ProjectDefinitionTest {

  @Test
  public void shouldSetKey() {
    ProjectDefinition def = ProjectDefinition.create();
    def.setKey("mykey");
    assertThat(def.getKey(), is("mykey"));
  }
}
</pre>Z
CODE_SMELL
ì
squid:S2925É
squidS2925*"Thread.sleep" should not be used in tests"MAJOR*java:≠<p>Using <code>Thread.sleep</code> in a test is just generally a bad idea. It creates brittle tests that can fail unpredictably depending on
environment ("Passes on my machine!") or load. Don't rely on timing (use mocks) or use libraries such as <code>Awaitility</code> for asynchroneous
testing. </p>
<h2>Noncompliant Code Example</h2>
<pre>
@Test
public void testDoTheThing(){

  MyClass myClass = new MyClass();
  myClass.doTheThing();

  Thread.sleep(500);  // Noncompliant
  // assertions...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@Test
public void testDoTheThing(){

  MyClass myClass = new MyClass();
  myClass.doTheThing();

  await().atMost(2, Duration.SECONDS).until(didTheThing());  // Compliant
  // assertions...
}

private Callable&lt;Boolean&gt; didTheThing() {
  return new Callable&lt;Boolean&gt;() {
    public Boolean call() throws Exception {
      // check the condition that must be fulfilled...
    }
  };
}
</pre>Z
CODE_SMELL


squid:S1711‡

squidS17116Standard functional interfaces should not be redefined"MAJOR*java:˛	<p>Just as there is little justification for writing your own String class, there is no good reason to re-define one of the existing, standard
functional interfaces.</p>
<p>Doing so may seem tempting, since it would allow you to specify a little extra context with the name. But in the long run, it will be a source of
confusion, because maintenance programmers will wonder what is different between the custom functional interface and the standard one.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@FunctionalInterface
public interface MyInterface { // Noncompliant
	double toDouble(int a);
}

@FunctionalInterface
public interface ExtendedBooleanSupplier { // Noncompliant
  boolean get();
  default boolean isFalse() {
    return !get();
  }
}

public class MyClass {
    private int a;
    public double myMethod(MyInterface instance){
	return instance.toDouble(a);
    }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@FunctionalInterface
public interface ExtendedBooleanSupplier extends BooleanSupplier { // Compliant, extends java.util.function.BooleanSupplier
  default boolean isFalse() {
    return !getAsBoolean();
  }
}

public class MyClass {
    private int a;
    public double myMethod(IntToDoubleFunction instance){
	return instance.applyAsDouble(a);
    }
}
</pre>Z
CODE_SMELL
¨
squid:S1710ú
squidS1710,Annotation repetitions should not be wrapped"MINOR*java:ƒ<p>Before Java 8 if you needed to use multiple instances of the same annotation, they had to be wrapped in a container annotation. With Java 8, that's
no longer necessary, allowing for cleaner, more readable code.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@SomeAnnotations({  // Noncompliant
  @SomeAnnotation(..a..),
  @SomeAnnotation(..b..),
  @SomeAnnotation(..c..),
})
public class SomeClass {
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@SomeAnnotation(..a..)
@SomeAnnotation(..b..)
@SomeAnnotation(..c..)
public class SomeClass {
  ...
}
</pre>Z
CODE_SMELL
î

squid:S124Ö
squidS124,Track comments matching a regular expression"MAJOR*java:¨<p>This rule template can be used to create rules which will be triggered when a comment matches a given regular expression.</p>
<p>For example, one can create a rule with the regular expression <code>.*TODO.*</code> to match all comment containing "TODO".</p>
<p>Note that, in order to match TODO regardless of the case, the <code>(?i)</code> modifier should be prepended to the expression, as in
<code>(?i).*TODO.*</code>.</p>@Z
CODE_SMELL
’
 squid:MethodCyclomaticComplexity∞
squidMethodCyclomaticComplexity!Methods should not be too complex"CRITICAL*java2S1541:ƒ<p>The cyclomatic complexity of methods should not exceed a defined threshold.</p>
<p>Complex code can perform poorly and will in any case be difficult to understand and therefore to maintain.</p>Z
CODE_SMELL
ø

squid:S128∞
squidS128?Switch cases should end with an unconditional "break" statement"MAJOR*java:Õ<p>When the execution is not explicitly terminated at the end of a switch case, it continues to execute the statements of the following case. While
this is sometimes intentional, it often is a mistake which leads to unexpected behavior. </p>
<h2>Noncompliant Code Example</h2>
<pre>
switch (myVariable) {
  case 1:
    foo();
    break;
  case 2:  // Both 'doSomething()' and 'doSomethingElse()' will be executed. Is it on purpose ?
    doSomething();
  default:
    doSomethingElse();
    break;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
switch (myVariable) {
  case 1:
    foo();
    break;
  case 2:
    doSomething();
    break;
  default:
    doSomethingElse();
    break;
}
</pre>
<h2>Exceptions</h2>
<p>This rule is relaxed in the following cases:</p>
<pre>
switch (myVariable) {
  case 0:                                // Empty case used to specify the same behavior for a group of cases.
  case 1:
    doSomething();
    break;
  case 2:                                // Use of return statement
    return;
  case 3:                                // Use of throw statement
    throw new IllegalStateException();
  case 4:                                // Use of continue statement
    continue;
  default:                               // For the last case, use of break statement is optional
    doSomethingElse();
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 15.0 - The MISRA C <em>switch</em> syntax shall be used. </li>
  <li> MISRA C:2004, 15.2 - An unconditional break statement shall terminate every non-empty switch clause </li>
  <li> MISRA C++:2008, 6-4-3 - A switch statement shall be a well-formed switch statement. </li>
  <li> MISRA C++:2008, 6-4-5 - An unconditional throw or break statement shall terminate every non-empty switch-clause </li>
  <li> MISRA C:2012, 16.1 - All switch statements shall be well-formed </li>
  <li> MISRA C:2012, 16.3 - An unconditional break statement shall terminate every switch-clause </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/484.html">MITRE, CWE-484</a> - Omitted Break Statement in Switch </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/YIFLAQ">CERT, MSC17-C.</a> - Finish every set of statements associated with a case
  label with a break statement </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/ZoFLAQ">CERT, MSC18-CPP.</a> - Finish every set of statements associated with a case
  label with a break statement </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/ewHAAQ">CERT, MSC52-J.</a> - Finish every set of statements associated with a case
  label with a break statement </li>
</ul>ZBUG
à
squid:S1607¯
squidS1607Tests should not be ignored"MAJOR*java:±<p>When a test fails due, for example, to infrastructure issues, you might want to ignore it temporarily. But without some kind of notation about why
the test is being ignored, it may never be reactivated. Such tests are difficult to address without comprehensive knowledge of the project, and end up
polluting their projects.</p>
<p>This rule raises an issue for each ignored test that does not have a notation about why it is being skipped.</p>
<h2>Noncompliant Code Example</h2>
<pre>
[TestMethod]
[Ignore]  // Noncompliant
public void Test_DoTheThing() {
  // ...
</pre>
<h2>Compliant Solution</h2>
<pre>
[TestMethod]
[Ignore]  // renable when TCKT-1234 is fixed
public void Test_DoTheThing() {
  // ...
</pre>
<p>or</p>
<pre>
[TestMethod]
[Ignore]
[WorkItem(1234)]
public void Test_DoTheThing() {
  // ...
</pre>Z
CODE_SMELL
¥
squid:S1849§
squidS18496"Iterator.hasNext()" should not call "Iterator.next()""MAJOR*java:…<p>Calling <code>Iterator.hasNext()</code> is not supposed to have any side effects, and therefore should not change the state of the iterator.
<code>Iterator.next()</code> advances the iterator by one item. So calling it inside <code>Iterator.hasNext()</code>, breaks the
<code>hasNext()</code> contract, and will lead to unexpected behavior in production.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class FibonacciIterator implements Iterator&lt;Integer&gt;{
...
@Override
public boolean hasNext() {
  if(next() != null) {
    return true;
  }
  return false;
}
...
}
</pre>ZBUG
Ç	
squid:S1604Ú
squidS1604HAnonymous inner classes containing only one method should become lambdas"MAJOR*java:˛<p>Before Java 8, the only way to partially support closures in Java was by using anonymous inner classes. But the syntax of anonymous classes may
seem unwieldy and unclear.</p>
<p>With Java 8, most uses of anonymous inner classes should be replaced by lambdas to highly increase the readability of the source code.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
myCollection.stream().map(new Mapper&lt;String,String&gt;() {
  public String map(String input) {
    return new StringBuilder(input).reverse().toString();
  }
});

Predicate&lt;String&gt; isEmpty = new Predicate&lt;String&gt; {
    boolean test(String myString) {
        return myString.isEmpty();
    }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
myCollection.stream().map(input -&gt; new StringBuilder(input).reverse().toString());

Predicate&lt;String&gt; isEmpty = myString -&gt; myString.isEmpty();
</pre>Z
CODE_SMELL
˙
squid:S1845Í
squidS1845OMethods and field names should not be the same or differ only by capitalization"BLOCKER*java:Ì<p>Looking at the set of methods in a class, including superclass methods, and finding two methods or fields that differ only by capitalization is
confusing to users of the class. It is similarly confusing to have a method and a field which differ only in capitalization or a method and a field
with exactly the same name and visibility.</p>
<p>In the case of methods, it may have been a mistake on the part of the original developer, who intended to override a superclass method, but instead
added a new method with nearly the same name.</p>
<p>Otherwise, this situation simply indicates poor naming. Method names should be action-oriented, and thus contain a verb, which is unlikely in the
case where both a method and a member have the same name (with or without capitalization differences). However, renaming a public method could be
disruptive to callers. Therefore renaming the member is the recommended action.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Car{

  public DriveTrain drive;

  public void tearDown(){...}

  public void drive() {...}  // Noncompliant; duplicates field name
}

public class MyCar extends Car{
  public void teardown(){...}  // Noncompliant; not an override. It it really what's intended?

  public void drivefast(){...}

  public void driveFast(){...} //Huh?
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Car{

  private DriveTrain drive;

  public void tearDown(){...}

  public void drive() {...}  // field visibility reduced
}

public class MyCar extends Car{
  @Override
  public void tearDown(){...}

  public void drivefast(){...}

  public void driveReallyFast(){...}

}
</pre>Z
CODE_SMELL
õ

squid:S1844ã

squidS1844j"Object.wait(...)" should never be called on objects that implement "java.util.concurrent.locks.Condition""MAJOR*java:ı<p>From the Java API documentation:</p>
<blockquote>
  <p><code>Condition</code> factors out the <code>Object</code> monitor methods (<code>wait</code>, <code>notify</code> and <code>notifyAll</code>)
  into distinct objects to give the effect of having multiple wait-sets per object, by combining them with the use of arbitrary Lock implementations.
  Where a <code>Lock</code> replaces the use of <code>synchronized</code> methods and statements, a <code>Condition</code> replaces the use of the
  <code>Object</code> monitor methods.</p>
</blockquote>
<p>The purpose of implementing the <code>Condition</code> interface is to gain access to its more nuanced <code>await</code> methods. Therefore,
calling the method <code>Object.wait(...)</code> on a class implementing the <code>Condition</code> interface is silly and confusing.</p>
<h2>Noncompliant Code Example</h2>
<pre>
final Lock lock = new ReentrantLock();
final Condition notFull  = lock.newCondition();
...
notFull.wait();
</pre>
<h2>Compliant Solution</h2>
<pre>
final Lock lock = new ReentrantLock();
final Condition notFull  = lock.newCondition();
...
notFull.await();
</pre>Z
CODE_SMELL
π
squid:S1602©
squidS1602OLamdbas containing only one statement should not nest this statement in a block"MINOR*java:Æ<p>There are two ways to write lambdas that contain single statement, but one is definitely more compact and readable than the other.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>8</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
x -&gt; {System.out.println(x+1);}
(a, b) -&gt; { return a+b; }
</pre>
<h2>Compliant Solution</h2>
<pre>
x -&gt; System.out.println(x+1)
(a, b) -&gt; a+b    //For return statement, the return keyword should also be dropped
</pre>Z
CODE_SMELL
«

squid:MissingDeprecatedCheck¶

squidMissingDeprecatedCheckGDeprecated elements should have both the annotation and the Javadoc tag"MAJOR*java2S1123:õ	<p>Deprecation should be marked with both the <code>@Deprecated</code> annotation and @deprecated Javadoc tag. The annotation enables tools such as
IDEs to warn about referencing deprecated elements, and the tag can be used to explain when it was deprecated, why, and how references should be
refactored.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class MyClass {

  @Deprecated
  public void foo1() {
  }

  /**
    * @deprecated
    */
  public void foo2() {    // Noncompliant
  }

}
</pre>
<h2>Compliant Solution</h2>
<pre>
class MyClass {

  /**
    * @deprecated (when, why, refactoring advice...)
    */
  @Deprecated
  public void foo1() {
  }

  /**
    * @deprecated (when, why, refactoring advice...)
    */
  @Deprecated
  public void foo2() {
  }

}
</pre>
<h2>Exceptions</h2>
<p>The members and methods of a deprecated class or interface are ignored by this rule. The classes and interfaces themselves are still subject to
it.</p>
<pre>
/**
 * @deprecated (when, why, etc...)
 */
@Deprecated
class Qix  {

  public void foo() {} // Compliant; class is deprecated

}

/**
 * @deprecated (when, why, etc...)
 */
@Deprecated
interface Plop {

  void bar();

}
</pre>Z
CODE_SMELL
å

squid:S135˝
squidS135KLoops should not contain more than a single "break" or "continue" statement"MAJOR*java:á<p>Restricting the number of <code>break</code> and <code>continue</code> statements in a loop is done in the interest of good structured programming.
</p>
<p>One <code>break</code> and <code>continue</code> statement is acceptable in a loop, since it facilitates optimal coding. If there is more than one,
the code should be refactored to increase readability.</p>
<h2>Noncompliant Code Example</h2>
<pre>
for (int i = 1; i &lt;= 10; i++) {     // Noncompliant - 2 continue - one might be tempted to add some logic in between
  if (i % 2 == 0) {
    continue;
  }

  if (i % 3 == 0) {
    continue;
  }

  System.out.println("i = " + i);
}
</pre>Z
CODE_SMELL
‰

squid:S138’
squidS138&Methods should not have too many lines"MAJOR*java:Ñ<p>A method that grows too large tends to aggregate too many responsibilities. Such method inevitably become harder to understand and therefore harder
to maintain.</p>
<p>Above a specific threshold, it is strongly advised to refactor into smaller methods which focus on well-defined tasks. Those smaller methods will
not only be easier to understand, but also probably easier to test.</p>Z
CODE_SMELL
œ
squid:S3038ø
squidS3038(Abstract methods should not be redundant"MINOR*java:Î<p>There's no point in redundantly defining an <code>abstract</code> method with the same signature as a method in an <code>interface</code> that the
class <code>implements</code>. Any concrete child classes will have to implement the method either way.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public interface Reportable {
  String getReport();
}

public abstract class AbstractRuleReport implements Reportable{
  public abstract String getReport();  // Noncompliant

  // ...
}
</pre>Z
CODE_SMELL
ç
squid:S2188˝
squidS2188*JUnit test cases should call super methods"BLOCKER*java:•<p>Overriding a parent class method prevents that method from being called unless an explicit <code>super</code> call is made in the overriding
method. In some cases not calling the <code>super</code> method is acceptable, but not with <code>setUp</code> and <code>tearDown</code> in a JUnit 3
<code>TestCase</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClassTest extends MyAbstractTestCase {

  private MyClass myClass;
    @Override
    protected void setUp() throws Exception {  // Noncompliant
      myClass = new MyClass();
    }
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClassTest extends MyAbstractTestCase {

  private MyClass myClass;
    @Override
    protected void setUp() throws Exception {
      super.setUp();
      myClass = new MyClass();
    }
</pre>Z
CODE_SMELL
‰
squid:S3398‘
squidS3398O"private" methods called only by inner classes should be moved to those classes"MINOR*java:Ÿ<p>When a <code>private</code> method is only invoked by an inner class, there's no reason not to move it into that class. It will still have the same
access to the outer class' members, but the outer class will be clearer and less cluttered.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Outie {
  private int i=0;

  private void increment() {  // Noncompliant
    i++;
  }

  public class Innie {
    public void doTheThing() {
      Outie.this.increment();
    }
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Outie {
  private int i=0;

  public class Innie {
    public void doTheThing() {
      Outie.this.increment();
    }

    private void increment() {
      Outie.this.i++;
    }
  }
}
</pre>Z
CODE_SMELL
¬
squid:S2068≤
squidS2068$Credentials should not be hard-coded"BLOCKER*java:›<p>Because it is easy to extract strings from a compiled application, credentials should never be hard-coded. Do so, and they're almost guaranteed to
end up in the hands of an attacker. This is particularly true for applications that are distributed.</p>
<p>Credentials should be stored outside of the code in a strongly-protected encrypted configuration file or database.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Connection conn = null;
try {
  conn = DriverManager.getConnection("jdbc:mysql://localhost/test?" +
        "user=steve&amp;password=blue"); // Noncompliant
  String uname = "steve";
  String password = "blue";
  conn = DriverManager.getConnection("jdbc:mysql://localhost/test?" +
        "user=" + uname + "&amp;password=" + password); // Noncompliant

  java.net.PasswordAuthentication pa = new java.net.PasswordAuthentication("userName", "1234".toCharArray());  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
Connection conn = null;
try {
  String uname = getEncryptedUser();
  String password = getEncryptedPass();
  conn = DriverManager.getConnection("jdbc:mysql://localhost/test?" +
        "user=" + uname + "&amp;password=" + password);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/798">MITRE, CWE-798</a> - Use of Hard-coded Credentials </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/259">MITRE, CWE-259</a> - Use of Hard-coded Password </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Porous Defenses </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/qQCHAQ">CERT, MSC03-J.</a> - Never hard code sensitive information </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management">OWASP Top Ten 2013 Category A2</a> -
  Broken Authentication and Session Management </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#HARD_CODE_PASSWORD">Hard Coded Password</a> </li>
</ul>ZVULNERABILITY
´
squid:S2186õ
squidS21864JUnit assertions should not be used in "run" methods"CRITICAL*java:∏<p>JUnit assertions should not be made from the <code>run</code> method of a <code>Runnable</code>, because failed assertions result in
<code>AssertionError</code>s being thrown. If the error is thrown from a thread other than the one that ran the test, the thread will exit but the
test won't fail.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void run() {
  // ...
  Assert.assertEquals(expected, actual);  // Noncompliant
}
</pre>Z
CODE_SMELL
Ñ
squid:S2065Ù
squidS2065<Fields in non-serializable classes should not be "transient""MINOR*java:å<p><code>transient</code> is used to mark fields in a <code>Serializable</code> class which will not be written out to file (or stream). In a class
that does not implement <code>Serializable</code>, this modifier is simply wasted keystrokes, and should be removed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
class Vegetable {  // does not implement Serializable
  private transient Season ripe;  // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
class Vegetable {
  private Season ripe;
  // ...
}
</pre>Z
CODE_SMELL
û
squid:S2187é
squidS2187TestCases should contain tests"BLOCKER*java:¬<p>There's no point in having a JUnit <code>TestCase</code> without any test methods. Similarly, you shouldn't have a file in the tests directory with
"Test" in the name, but no tests in the file. Doing either of these things may lead someone to think that uncovered classes have been tested.</p>
<p>This rule raises an issue when files in the test directory have "Test" in the name or implement <code>TestCase</code> but don't contain any
tests.</p>Z
CODE_SMELL
è
squid:S3034ˇ
squidS3034SRaw byte values should not be used in bitwise operations in combination with shifts"MAJOR*java:á<p>When reading bytes in order to build other primitive values such as <code>int</code>s or <code>long</code>s, the <code>byte</code> values are
automatically promoted, but that promotion can have unexpected results.</p>
<p>For instance, the binary representation of the integer 640 is <code>0b0000_0010_1000_0000</code>, which can also be written with the array of
(unsigned) bytes <code>[2, 128]</code>. However, since Java uses two's complement, the representation of the integer in signed bytes will be <code>[2,
-128]</code> (because the <code>byte</code> <code>0b1000_0000</code> is promoted to the <code>int</code>
<code>0b1111_1111_1111_1111_1111_1111_1000_0000</code>). Consequently, trying to reconstruct the initial integer by shifting and adding the values of
the bytes without taking care of the sign will not produce the expected result. </p>
<p>To prevent such accidental value conversion, use bitwise and (<code>&amp;</code>) to combine the <code>byte</code> value with <code>0xff</code>
(255) and turn all the higher bits back off.</p>
<p>This rule raises an issue any time a <code>byte</code> value is used as an operand without <code>&amp; 0xff</code>, when combined with shifts.</p>
<h2>Noncompliant Code Example</h2>
<pre>
  int intFromBuffer() {
    int result = 0;
    for (int i = 0; i &lt; 4; i++) {
      result = (result &lt;&lt; 8) | readByte(); // Noncompliant
    }
    return result;
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
  int intFromBuffer() {
    int result = 0;
    for (int i = 0; i &lt; 4; i++) {
      result = (result &lt;&lt; 8) | (readByte() &amp; 0xff);
    }
    return result;
  }
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SAHEAw">CERT, NUM52-J.</a> - Be aware of numeric promotion behavior </li>
</ul>ZBUG
π

squid:S2066©

squidS2066K"Serializable" inner classes of non-serializable classes should be "static""MINOR*java:π	<p>Serializing a non-<code>static</code> inner class will result in an attempt at serializing the outer class as well. If the outer class is not
serializable, then serialization will fail, resulting in a runtime error. </p>
<p>Making the inner class <code>static</code> (i.e. "nested") avoids this problem, therefore inner classes should be <code>static</code> if possible.
However, you should be aware that there are semantic differences between an inner class and a nested one: </p>
<ul>
  <li> an inner class can only be instantiated within the context of an instance of the outer class. </li>
  <li> a nested (<code>static</code>) class can be instantiated independently of the outer class. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Pomegranate {
  // ...

  public class Seed implements Serializable {  // Noncompliant; serialization will fail
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Pomegranate {
  // ...

  public static class Seed implements Serializable {
    // ...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/O4CpAQ">CERT SER05-J.</a> - Do not serialize instances of inner classes </li>
</ul>ZBUG
≈
squid:S2063µ
squidS2063$Comparators should be "Serializable""CRITICAL*java:‚<p>A non-serializable <code>Comparator</code> can prevent an otherwise-<code>Serializable</code> ordered collection from being serializable. Since the
overhead to make a <code>Comparator</code> serializable is usually low, doing so can be considered good defensive programming.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class FruitComparator implements Comparator&lt;Fruit&gt; {  // Noncompliant
  int compare(Fruit f1, Fruit f2) {...}
  boolean equals(Object obj) {...}
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class FruitComparator implements Comparator&lt;Fruit&gt;, Serializable {
  private static final long serialVersionUID = 1;

  int compare(Fruit f1, Fruit f2) {...}
  boolean equals(Object obj) {...}
}
</pre>Z
CODE_SMELL
ƒ
squid:S2184¥
squidS2184.Math operands should be cast before assignment"MINOR*java:·<p>When arithmetic is performed on integers, the result will always be an integer. You can assign that result to a <code>long</code>,
<code>double</code>, or <code>float</code> with automatic type conversion, but having started as an <code>int</code> or <code>long</code>, the result
will likely not be what you expect. </p>
<p>For instance, if the result of <code>int</code> division is assigned to a floating-point variable, precision will have been lost before the
assignment. Likewise, if the result of multiplication is assigned to a <code>long</code>, it may have already overflowed before the assignment.</p>
<p>In either case, the result will not be what was expected. Instead, at least one operand should be cast or promoted to the final type before the
operation takes place.</p>
<h2>Noncompliant Code Example</h2>
<pre>
float twoThirds = 2/3; // Noncompliant; int division. Yields 0.0
long millisInYear = 1_000*3_600*24*365; // Noncompliant; int multiplication. Yields 1471228928
long bigNum = Integer.MAX_VALUE + 2; // Noncompliant. Yields -2147483647
long bigNegNum =  Integer.MIN_VALUE-1; //Noncompliant, gives a positive result instead of a negative one.
Date myDate = new Date(seconds * 1_000); //Noncompliant, won't produce the expected result if seconds &gt; 2_147_483
...
public long compute(int factor){
  return factor * 10_000;  //Noncompliant, won't produce the expected result if factor &gt; 214_748
}

public float compute2(long factor){
  return factor / 123;  //Noncompliant, will be rounded to closest long integer
}
</pre>
<h2>Compliant Solution</h2>
<pre>
float twoThirds = 2f/3; // 2 promoted to float. Yields 0.6666667
long millisInYear = 1_000L*3_600*24*365; // 1000 promoted to long. Yields 31_536_000_000
long bigNum = Integer.MAX_VALUE + 2L; // 2 promoted to long. Yields 2_147_483_649
long bigNegNum =  Integer.MIN_VALUE-1L; // Yields -2_147_483_649
Date myDate = new Date(seconds * 1_000L);
...
public long compute(int factor){
  return factor * 10_000L;
}

public float compute2(long factor){
  return factor / 123f;
}
</pre>
<p>or</p>
<pre>
float twoThirds = (float)2/3; // 2 cast to float
long millisInYear = (long)1_000*3_600*24*365; // 1_000 cast to long
long bigNum = (long)Integer.MAX_VALUE + 2;
long bigNegNum =  (long)Integer.MIN_VALUE-1;
Date myDate = new Date((long)seconds * 1_000);
...
public long compute(long factor){
  return factor * 10_000;
}

public float compute2(float factor){
  return factor / 123;
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C++:2008, 5-0-8 - An explicit integral or floating-point conversion shall not increase the size of the underlying type of a cvalue
  expression. </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/190">MITRE, CWE-190</a> - Integer Overflow or Wraparound </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/woIyAQ">CERT, NUM50-J.</a> - Convert integers to floating point for floating-point
  operations </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/AxE">CERT, INT18-C.</a> - Evaluate integer expressions in a larger size before
  comparing or assigning to that size </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/1IAyAQ">CERT, INT18-CPP.</a> - Evaluate integer expressions in a larger size before
  comparing or assigning to that size </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Risky Resource Management </li>
</ul>ZBUG
Å
squid:S2185Ò
squidS2185"Silly math should not be performed"MAJOR*java:£<p>Certain math operations are just silly and should not be performed because their results are predictable.</p>
<p>In particular, <code>anyValue % 1</code> is silly because it will always return 0.</p>
<p>Casting a non-floating-point value to floating-point and then passing it to <code>Math.round</code>, <code>Math.ceil</code>, or
<code>Math.floor</code> is silly because the result will always be the original value. </p>
<p>These operations are silly with any constant value: <code>Math.abs</code>, <code>Math.ceil</code>, <code>Math.floor</code>, <code>Math.rint</code>,
<code>Math.round</code>.</p>
<p>And these oprations are silly with certain constant values:</p>
<table>
  <tbody>
    <tr>
      <th>Operation</th>
      <th>Value</th>
    </tr>
    <tr>
      <td>acos</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>asin</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>atan</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>atan2</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>cbrt</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>cos</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>cosh</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>exp</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>expm1</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>log</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>log10</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>sin</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>sinh</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>sqrt</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>tan</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>tanh</td>
      <td>0.0</td>
    </tr>
    <tr>
      <td>toDegrees</td>
      <td>0.0 or 1.0</td>
    </tr>
    <tr>
      <td>toRadians</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
<h2>Noncompliant Code Example</h2>
<pre>
public void doMath(int a)
double floor = Math.floor((double)a); // Noncompliant
double ceiling = Math.ceil(4.2);
double arcTan = Math.atan(0.0);
</pre>Z
CODE_SMELL
ƒ
squid:S2061¥
squidS2061?Custom serialization method signatures should meet requirements"MAJOR*java:–<p>Writers of <code>Serializable</code> classes can choose to let Java's automatic mechanisms handle serialization and deserialization, or they can
choose to handle it themselves by implementing specific methods. However, if the signatures of those methods are not exactly what is expected, they
will be ignored and the default serialization mechanisms will kick back in. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Watermelon implements Serializable {
  // ...
  void writeObject(java.io.ObjectOutputStream out)// Noncompliant; not private
        throws IOException
  {...}

  private void readObject(java.io.ObjectInputStream in)
  {...}

  public void readObjectNoData()  // Noncompliant; not private
  {...}

  static Object readResolve() throws ObjectStreamException  // Noncompliant; this method may have any access modifier, may not be static

  Watermelon writeReplace() throws ObjectStreamException // Noncompliant; this method may have any access modifier, but must return Object
  {...}
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Watermelon implements Serializable {
  // ...
  private void writeObject(java.io.ObjectOutputStream out)
        throws IOException
  {...}

  private void readObject(java.io.ObjectInputStream in)
        throws IOException, ClassNotFoundException
  {...}

  private void readObjectNoData()
        throws ObjectStreamException
  {...}

  protected Object readResolve() throws ObjectStreamException
  {...}

  private Object writeReplace() throws ObjectStreamException
  {...}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/4gAMAg">CERT, SER01-J.</a> - Do not deviate from the proper signatures of serialization
  methods </li>
</ul>ZBUG
Ø
squid:S3030ü
squidS30301Classes should not have too many "static" imports"MAJOR*java:¬<p>Importing a class statically allows you to use its <code>public static</code> members without qualifying them with the class name. That can be
handy, but if you import too many classes statically, your code can become confusing and difficult to maintain.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold value: 4</p>
<pre>
import static java.lang.Math.*;
import static java.util.Collections.*;
import static com.myco.corporate.Constants.*;
import static com.myco.division.Constants.*;
import static com.myco.department.Constants.*;  // Noncompliant
</pre>Z
CODE_SMELL
ë
squid:S2062Å
squidS2062+"readResolve" methods should be inheritable"CRITICAL*java:ß<p>The <code>readResolve()</code> method allows final tweaks to the state of an object during deserialization. Non-final classes which implement
<code>readResolve()</code>, should not set its visibility to <code>private</code> since it will then be unavailable to child classes.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit implements Serializable {
  private static final long serialVersionUID = 1;

  private Object readResolve() throws ObjectStreamException  // Noncompliant
  {...}

  //...
}

public class Raspberry extends Fruit implements Serializable {  // No access to parent's readResolve() method
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Fruit implements Serializable {
  private static final long serialVersionUID = 1;

  protected Object readResolve() throws ObjectStreamException
  {...}

  //...
}

public class Raspberry extends Fruit implements Serializable {
  //...
}
</pre>Z
CODE_SMELL
œ
squid:S2183ø
squidS2183PInts and longs should not be shifted by zero or more than their number of bits-1"MINOR*java: <p>Since an <code>int</code> is a 32-bit variable, shifting by more than +/-31 is confusing at best and an error at worst. Shifting an
<code>int</code> by 32 is the same as shifting it by 0, and shifting it by 33 is the same as shifting it by 1.</p>
<p>Similarly, shifting a <code>long</code> by +/-64 is the same as shifting it by 0, and shifting it by 65 is the same as shifting it by 1.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int shift(int a) {
  return a &lt;&lt; 48;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public int shift(int a) {
  return a &lt;&lt; 16;
}
</pre>ZBUG
±
squid:S2060°
squidS2060>"Externalizable" classes should have no-arguments constructors"MAJOR*java:æ<p>An <code>Externalizable</code> class is one which handles its own <code>Serialization</code> and deserialization. During deserialization, the first
step in the process is a default instantiation using the class' no-argument constructor. Therefore an <code>Externalizable</code> class without a
no-arg constructor cannot be deserialized.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Tomato implements Externalizable {  // Noncompliant; no no-arg constructor

  public Tomato (String color, int weight) { ... }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Tomato implements Externalizable {

  public Tomato() { ... }
  public Tomato (String color, int weight) { ... }
}
</pre>ZBUG
˚

squid:S106Ï
squidS106<Standard outputs should not be used directly to log anything"MAJOR*java:Ö<p>When logging a message there are several important requirements which must be fulfilled:</p>
<ul>
  <li> The user must be able to easily retrieve the logs </li>
  <li> The format of all logged message must be uniform to allow the user to easily read the log </li>
  <li> Logged data must actually be recorded </li>
  <li> Sensitive data must only be logged securely </li>
</ul>
<p>If a program directly writes to the standard outputs, there is absolutely no way to comply with those requirements. That's why defining and using a
dedicated logger is highly recommended.</p>
<h2>Noncompliant Code Example</h2>
<pre>
System.out.println("My Message");  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
logger.log("My Message");
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/RoElAQ">CERT, ERR02-J.</a> - Prevent exceptions while logging data </li>
</ul>Z
CODE_SMELL
Õ

squid:S109æ
squidS109 Magic numbers should not be used"MAJOR*java:Û<p>A magic number is a number that comes out of nowhere, and is directly used in a statement. Magic numbers are often used, for instance to limit the
number of iterations of a loops, to test the value of a property, etc.</p>
<p>Using magic numbers may seem obvious and straightforward when you're writing a piece of code, but they are much less obvious and straightforward at
debugging time.</p>
<p>That is why magic numbers must be demystified by first being assigned to clearly named variables before being used.</p>
<p>-1, 0 and 1 are not considered magic numbers.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public static void doSomething() {
	for(int i = 0; i &lt; 4; i++){                 // Noncompliant, 4 is a magic number
		...
	}
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public static final int NUMBER_OF_CYCLES = 4;
public static void doSomething() {
  for(int i = 0; i &lt; NUMBER_OF_CYCLES ; i++){
    ...
  }
}
</pre>
<h2>Exceptions</h2>
<p>This rule ignores <code>hashCode</code> methods.</p>Z
CODE_SMELL
»
squid:S2078∏
squidS20781Values passed to LDAP queries should be sanitized"CRITICAL*java:’<p>Applications that execute LDAP queries should neutralize any externally-provided values in those commands. Failure to do so could allow an attacker
to include input that changes the query so that unintended commands are executed, or sensitive data is exposed. Unhappily LDAP doesn't provide any
prepared statement interfaces like SQL to easily remove this risk. So each time a LDAP query is built dynamically this rule logs an issue.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public User lookupUser(String username, String base, String [] requestedAttrs) {

  // ...
  DirContext dctx = new InitialDirContext(env);

  SearchControls sc = new SearchControls();
  sc.setReturningAttributes(requestedAttrs);  // Noncompliant
  sc.setSearchScope(SearchControls.SUBTREE_SCOPE);

  String filter = "(&amp;(objectClass=user)(sAMAccountName=" + username + "))";

  NamingEnumeration results = dctx.search(base,  // Noncompliant
        filter,  // Noncompliant; parameter concatenated directly into string
        sc);
</pre>
<h2>Compliant Solution</h2>
<pre>
public User lookupUser(String username, String base, String [] requestedAttrs) {

  // ...
  DirContext dctx = new InitialDirContext(env);

  SearchControls sc = new SearchControls();
  sc.setReturningAttributes(buildAttrFilter(requestedAttrs));  // Compliant; method presumably scrubs input
  sc.setSearchScope(SearchControls.SUBTREE_SCOPE);

  String useBase = "ou=People";
  if (! base.startsWith(useBase)) {
    useBase = base;
  }

  String filter = "(&amp;(objectClass=user)(sAMAccountName=" + username.replaceAll("[()| ]","") + "))";

  NamingEnumeration results = dctx.search(useBase,  // Compliant; originally value used conditionally
        filter,  // Compliant; parameter NOT concatenated directly into string
        sc);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/90">MITRE CWE-90</a> - Improper Neutralization of Special Elements used in an LDAP Query ('LDAP
  Injection') </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A1-Injection">OWASP Top Ten 2013 Category A1</a> - Injection </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/CgLEAw">CERT, IDS54-J.</a> - Prevent LDAP injection </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#LDAP_INJECTION">Potential LDAP Injection</a> </li>
</ul>ZVULNERABILITY
·
squid:S3047—
squidS30473Multiple loops over the same set should be combined"MINOR*java:˘<p>When a method loops multiple over the same set of data, whether it's a list or a set of numbers, it is highly likely that the method could be made
more efficient by combining the loops into a single set of iterations.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomethingToAList(List&lt;String&gt; strings) {
  for (String str : strings) {
    doStep1(str);
  }
  for (String str : strings) {  // Noncompliant
    doStep2(str);
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomethingToAList(List&lt;String&gt; strings) {
  for (String str : strings) {
    doStep1(str);
    doStep2(str);
  }
}
</pre>ZBUG
˜
squid:S2197Á
squidS21979Modulus results should not be checked for direct equality"MINOR*java:â<p>When the modulus of a negative number is calculated, the result will either be negative or zero. Thus, comparing the modulus of a variable for
equality with a positive number (or a negative one) could result in unexpected results. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public boolean isOdd(int x) {
  return x % 2 == 1;  // Noncompliant; if x is an odd negative, x % 2 == -1
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public boolean isOdd(int x) {
  return x % 2 != 0;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/xAHAAQ">CERT, NUM51-J.</a> - Do not assume that the remainder operator always returns a
  nonnegative result for integral operands </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NQBi">CERT, INT10-C</a> - Do not assume a positive remainder when using the % operator
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/_YBLAQ">CERT, INT10-CPP.</a> - Do not assume a positive remainder when using the %
  operator </li>
</ul>ZBUG
÷
squid:S2076∆
squidS20760Values passed to OS commands should be sanitized"CRITICAL*java:‰<p>Applications that execute operating system commands or execute commands that interact with the underlying system should neutralize any
externally-provided values used in those commands. Failure to do so could allow an attacker to include input that executes unintended commands, or
exposes sensitive data.</p>
<p>This rule logs issues for dynamically-built commands, and when parameter values are used to influence how a command is run. it's then up to the
auditor to figure out if the command execution is secure or not. </p>
<h2>Noncompliant Code Example</h2>
<pre>
public void listContent(String input) {
  Runtime rt = Runtime.getRuntime();
  rt.exec("ls " + input); // Noncompliant; input could easily contain extra commands
  ...
}

public void execute(String command, String argument) {
  ProcessBuilder pb = new ProcessBuilder(command, argument); // Noncompliant
  ...
}

public void doTheThing(String path) {
  ProcessBuilder pb = new ProcessBuilder("ls");  // command hard coded. So far, so good
  pb.redirectOutput(path);  // Noncompliant
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/78">MITRE, CWE-78</a> - Improper Neutralization of Special Elements used in an OS Command </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/88">MITRE, CWE-88</a> - Argument Injection or Modification </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A1-Injection">OWASP Top Ten 2013 Category A1</a> - Injection </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Insecure Interaction Between Components </li>
  <li> Derived from the FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#COMMAND_INJECTION">Potential Command Injection</a>
  </li>
</ul>ZVULNERABILITY
º
squid:S2077¨
squidS2077%SQL binding mechanisms should be used"BLOCKER*java:÷<p>Applications that execute SQL commands should neutralize any externally-provided values used in those commands. Failure to do so could allow an
attacker to include input that changes the query so that unintended commands are executed, or sensitive data is exposed.</p>
<p>This rule checks that method parameters are not used directly in non-Hibernate SQL statements, and that parameter binding, rather than
concatenation is used in Hibernate statements.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public User getUser(Connection con, String user) throws SQLException {

  Statement stmt1 = null;
  Statement stmt2 = null;
  PreparedStatement pstmt;
  try {
    stmt1 = con.createStatement();
    ResultSet rs1 = stmt1.executeQuery("GETDATE()"); // Compliant; parameters not used here

    stmt2 = con.createStatement();
    ResultSet rs2 = stmt2.executeQuery("select FNAME, LNAME, SSN " +
                 "from USERS where UNAME=" + user);  // Noncompliant; parameter concatenated directly into query

    pstmt = con.prepareStatement("select FNAME, LNAME, SSN " +
                 "from USERS where UNAME=" + user);  // Noncompliant; parameter concatenated directly into query
    ResultSet rs3 = pstmt.executeQuery();

    //...
}

public User getUserHibernate(org.hibernate.Session session, String userInput) {

  org.hibernate.Query query = session.createQuery(  // Compliant
            "FROM students where fname = " + userInput);  // Noncompliant; parameter binding should be used instead
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public User getUser(Connection con, String user) throws SQLException {

  Statement stmt1 = null;
  PreparedStatement pstmt = null;
  String query = "select FNAME, LNAME, SSN " +
                 "from USERS where UNAME=?"
  try {
    stmt1 = con.createStatement();
    ResultSet rs1 = stmt1.executeQuery("GETDATE()");

    pstmt = con.prepareStatement(query);
    pstmt.setString(1, user);  // Compliant; PreparedStatements escape their inputs.
    ResultSet rs2 = pstmt.executeQuery();

    //...
  }
}

public User getUserHibernate(org.hibernate.Session session, String userInput) {

  org.hibernate.Query query =  session.createQuery("FROM students where fname = ?");
  query = query.setParameter(0,userInput);  // Parameter binding escapes all input
  // ...
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/89">MITRE, CWE-89</a> - Improper Neutralization of Special Elements used in an SQL Command </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/564.html">MITRE, CWE-564</a> - SQL Injection: Hibernate </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/20.html">MITRE, CWE-20</a> - Improper Input Validation </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/943.html">MITRE, CWE-943</a> - Improper Neutralization of Special Elements in Data Query Logic
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/PgIRAg">CERT, IDS00-J.</a> - Prevent SQL injection </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A1-Injection">OWASP Top Ten 2013 Category A1</a> - Injection </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Insecure Interaction Between Components </li>
  <li> Derived from FindSecBugs rules <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#SQL_INJECTION_JPA">Potential SQL/JPQL Injection
  (JPA)</a>, <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#SQL_INJECTION_JDO">Potential SQL/JDOQL Injection (JDO)</a>, <a
  href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#SQL_INJECTION_HIBERNATE">Potential SQL/HQL Injection (Hibernate)</a> </li>
</ul>ZVULNERABILITY
˝
squid:EmptyStatementUsageCheck⁄
squidEmptyStatementUsageCheck"Empty statements should be removed"MINOR*java2S1116:˘<p>Empty statements, i.e. <code>;</code>, are usually introduced by mistake, for example because:</p>
<ul>
  <li> It was meant to be replaced by an actual statement, but this was forgotten. </li>
  <li> There was a typo which lead the semicolon to be doubled, i.e. <code>;;</code>. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
void doSomething() {
  ;                                                       // Noncompliant - was used as a kind of TODO marker
}

void doSomethingElse() {
  System.out.println("Hello, world!");;                     // Noncompliant - double ;
  ...
  for (int i = 0; i &lt; 3; System.out.println(i), i++);       // Noncompliant - Rarely, they are used on purpose as the body of a loop. It is a bad practice to have side-effects outside of the loop body
  ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
void doSomething() {}

void doSomethingElse() {
  System.out.println("Hello, world!");
  ...
  for (int i = 0; i &lt; 3; i++){
    System.out.println(i);
  }
  ...
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 14.3 - Before preprocessing, a null statement shall only occur on a line by itself; it may be followed by a comment provided that
  the first character following the null statement is a white-space character. </li>
  <li> MISRA C++:2008, 6-2-3 - Before preprocessing, a null statement shall only occur on a line by itself; it may be followed by a comment, provided
  that the first character following the null statement is a white-space character. </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYA5">CERT, MSC12-C.</a> - Detect and remove code that has no effect or is never
  executed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/SIIyAQ">CERT, MSC12-CPP.</a> - Detect and remove code that has no effect </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/7gCTAw">CERT, MSC51-J.</a> - Do not place a semicolon immediately following an if, for,
  or while condition </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/i4FtAg">CERT, EXP15-C.</a> - Do not place a semicolon on the same line as an if, for,
  or while statement </li>
</ul>ZBUG
ú	
squid:S3042å	
squidS3042C"writeObject" should not be the only "synchronized" code in a class"MAJOR*java:ù<p>The purpose of synchronization is to ensure that only one thread executes a given block of code at a time. There's no real problem with marking
<code>writeObject</code> <code>synchronized</code>, but if it's highly suspicious if this serialization-related method the only
<code>synchronized</code> code in a <code>class</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class RubberBall {

  private Color color;
  private int diameter;

  public RubberBall(Color color, int diameter) {
    // ...
  }

  public void bounce(float angle, float velocity) {
    // ...
  }

  private synchronized void writeObject(ObjectOutputStream stream) throws IOException { // Noncompliant
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class RubberBall {

  private Color color;
  private int diameter;

   public RubberBall(Color color, int diameter) {
    // ...
  }

  public void bounce(float angle, float velocity) {
    // ...
  }

  private void writeObject(ObjectOutputStream stream) throws IOException {
    // ...
  }
}
</pre>Z
CODE_SMELL
¬
squid:S3282≤
squidS3282<EJB interceptor exclusions should be declared as annotations"BLOCKER*java:»<p>Exclusions for default interceptors can be declared either in xml or as class annotations. Since annotations are more visible to maintainers, they
are preferred.</p>
<h2>Noncompliant Code Example</h2>
<pre>
&lt;assembly-descriptor&gt;
      &lt;interceptor-binding&gt;
         &lt;ejb-name&gt;MyExcludedClass&lt;/ejb-name&gt;
         &lt;exclude-default-interceptors&gt;true&lt;/exclude-default-interceptors&gt; &lt;!-- Noncompliant --&gt;
         &lt;exclude-class-interceptors&gt;true&lt;/exclude-class-interceptors&gt; &lt;!-- Noncomopliant --&gt;
         &lt;method&gt;
           &lt;method-name&gt;doTheThing&lt;/method-name&gt;
         &lt;/method&gt;
      &lt;/interceptor-binding&gt;

&lt;/assembly-descriptor&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
@ExcludeDefaultInterceptors
public class MyExcludedClass implements MessageListener
{

  @ExcludeClassInterceptors
  @ExcludeDefaultInterceptors
  public void doTheThing() {
    // ...
  }
</pre>Z
CODE_SMELL
Æ
squid:S2070û
squidS2070;SHA-1 and Message-Digest hash algorithms should not be used"CRITICAL*java:±<p>The MD5 algorithm and its successor, SHA-1, are no longer considered secure, because it is too easy to create hash collisions with them. That is,
it takes too little computational effort to come up with a different input that produces the same MD5 or SHA-1 hash, and using the new, same-hash
value gives an attacker the same access as if he had the originally-hashed value. This applies as well to the other Message-Digest algorithms: MD2,
MD4, MD6.</p>
<p>This rule tracks usage of the <code>java.security.MessageDigest</code>, and <code>org.apache.commons.codec.digest.DigestUtils</code> classes to
instantiate MD or SHA-1 algorithms, and of Guava's <code>com.google.common.hash.Hashing sha1</code> and <code>md5</code> methods. </p>
<h2>Noncompliant Code Example</h2>
<pre>
MessageDigest md = MessageDigest.getInstance("SHA1");  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
MessageDigest md = MessageDigest.getInstance("SHA-256");
</pre>
<p>or</p>
<pre>
Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/328">MITRE, CWE-328</a> - Reversible One-Way Hash </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/327">MITRE, CWE-327</a> - Use of a Broken or Risky Cryptographic Algorithm </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Porous Defenses </li>
  <li> Derived from FindSecBugs rule <a href="http://h3xstream.github.io/find-sec-bugs/bugs.htm#WEAK_MESSAGE_DIGEST">MessageDigest Is Weak</a> </li>
</ul>ZVULNERABILITY
ç	
squid:S3281˝
squidS3281<Default EJB interceptors should be declared in "ejb-jar.xml""BLOCKER*java:ê<p>Default interceptors, such as application security interceptors, must be listed in the <code>ejb-jar.xml</code> file, or they will not be treated
as default. </p>
<p>This rule applies to projects that contain JEE Beans (any one of <code>javax.ejb.Singleton</code>, <code>MessageDriven</code>,
<code>Stateless</code> or <code>Stateful</code>).</p>
<h2>Noncompliant Code Example</h2>
<pre>
// file: ejb-interceptors.xml
&lt;assembly-descriptor&gt;
 &lt;interceptor-binding&gt;
      &lt;ejb-name&gt;*&lt;/ejb-name&gt;
      &lt;interceptor-class&gt;com.myco.ImportantInterceptor&lt;/interceptor-class&gt;&lt;!-- Noncompliant; will not be treated as default --&gt;
   &lt;/interceptor-binding&gt;
&lt;/assembly-descriptor&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
// file: ejb-jar.xml
&lt;assembly-descriptor&gt;
 &lt;interceptor-binding&gt;
      &lt;ejb-name&gt;*&lt;/ejb-name&gt;
      &lt;interceptor-class&gt;com.myco.ImportantInterceptor&lt;/interceptor-class&gt;
   &lt;/interceptor-binding&gt;
&lt;/assembly-descriptor&gt;
</pre>ZVULNERABILITY
Ö
squid:S2168ı
squidS2168)Double-checked locking should not be used"BLOCKER*java:•<p>Double-checked locking is the practice of checking a lazy-initialized object's state both before and after a <code>synchronized</code> block is
entered to determine whether or not to initialize the object.</p>
<p>It does not work reliably in a platform-independent manner without additional synchronization for mutable instances of anything other than
<code>float</code> or <code>int</code>. Using double-checked locking for the lazy initialization of any other type of primitive or mutable object
risks a second thread using an uninitialized or partially initialized member while the first thread is still creating it, and crashing the
program.</p>
<p>There are multiple ways to fix this. The simplest one is to simply not use double checked locking at all, and synchronize the whole method instead.
With early versions of the JVM, synchronizing the whole method was generally advised against for performance reasons. But <code>synchronized</code>
performance has improved a lot in newer JVMs, so this is now a preferred solution. If you prefer to avoid using <code>synchronized</code> altogether,
you can use an inner <code>static class</code> to hold the reference instead. Inner static classes are guaranteed to load lazily.</p>
<h2>Noncompliant Code Example</h2>
<pre>
@NotThreadSafe
public class DoubleCheckedLocking {
    private static Resource resource;

    public static Resource getInstance() {
        if (resource == null) {
            synchronized (DoubleCheckedLocking.class) {
                if (resource == null)
                    resource = new Resource();
            }
        }
        return resource;
    }

    static class Resource {

    }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
@ThreadSafe
public class SafeLazyInitialization {
    private static Resource resource;

    public synchronized static Resource getInstance() {
        if (resource == null)
            resource = new Resource();
        return resource;
    }

    static class Resource {
    }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://www.cs.umd.edu/~pugh/java/memoryModel/DoubleCheckedLocking.html">The "Double-Checked Locking is Broken" Declaration</a> </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/IgAZAg">CERT, LCK10-J.</a> - Use a correct form of the double-checked locking idiom
  </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/609.html">MITRE, CWE-609</a> - Double-checked locking </li>
  <li> <a href="https://docs.oracle.com/javase/specs/jls/se7/html/jls-12.html#jls-12.4">JLS 12.4</a> - Initialization of Classes and Interfaces </li>
</ul>ZBUG
ø	
squid:S2166Ø	
squidS2166FClasses named like "Exception" should extend "Exception" or a subclass"MAJOR*java:Ω<p>Clear, communicative naming is important in code. It helps maintainers and API users understand the intentions for and uses of a unit of code.
Using "exception" in the name of a class that does not extend <code>Exception</code> or one of its subclasses is a clear violation of the expectation
that a class' name will indicate what it is and/or does.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class FruitException {  // Noncompliant; this has nothing to do with Exception
  private Fruit expected;
  private String unusualCharacteristics;
  private boolean appropriateForCommercialExploitation;
  // ...
}

public class CarException {  // Noncompliant; the extends clause was forgotten?
  public CarException(String message, Throwable cause) {
  // ...
</pre>
<h2>Compliant Solution</h2>
<pre>
public class FruitSport {
  private Fruit expected;
  private String unusualCharacteristics;
  private boolean appropriateForCommercialExploitation;
  // ...
}

public class CarException extends Exception {
  public CarException(String message, Throwable cause) {
  // ...
</pre>Z
CODE_SMELL
¿
squid:S1199∞
squidS1199%Nested code blocks should not be used"MINOR*java:ﬂ<p>Nested code blocks can be used to create a new scope and restrict the visibility of the variables defined inside it. Using this feature in a method
typically indicates that the method has too many responsibilities, and should be refactored into smaller methods.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void evaluate(int operator) {
  switch (operator) {
    /* ... */
    case ADD: {                                // Noncompliant - nested code block '{' ... '}'
        int a = stack.pop();
        int b = stack.pop();
        int result = a + b;
        stack.push(result);
        break;
      }
    /* ... */
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void evaluate(int operator) {
  switch (operator) {
    /* ... */
    case ADD:                                  // Compliant
      evaluateAdd();
      break;
    /* ... */
  }
}

private void evaluateAdd() {
  int a = stack.pop();
  int b = stack.pop();
  int result = a + b;
  stack.push(result);
}
</pre>Z
CODE_SMELL
„
squid:S2167”
squidS21671"compareTo" should not return "Integer.MIN_VALUE""MINOR*java:˝<p>It is the sign, rather than the magnitude of the value returned from <code>compareTo</code> that matters. Returning <code>Integer.MIN_VALUE</code>
does <em>not</em> convey a higher degree of inequality, and doing so can cause errors because the return value of <code>compareTo</code> is sometimes
inversed, with the expectation that negative values become positive. However, inversing <code>Integer.MIN_VALUE</code> yields
<code>Integer.MIN_VALUE</code> rather than <code>Integer.MAX_VALUE</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public int compareTo(MyClass) {
  if (condition) {
    return Integer.MIN_VALUE;  // Noncompliant
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
public int compareTo(MyClass) {
  if (condition) {
    return -1;
  }
</pre>ZBUG
≥

squid:S3374£

squidS33740Struts validation forms should have unique names"BLOCKER*java:¬	<p>According to the Common Weakness Enumeration,</p>
<blockquote>
  If two validation forms have the same name, the Struts Validator arbitrarily chooses one of the forms to use for input validation and discards the
  other. This decision might not correspond to the programmer's expectations...
</blockquote>
<p>In such a case, it is likely that the two forms should be combined. At the very least, one should be removed.</p>
<h2>Noncompliant Code Example</h2>
<pre>
&lt;form-validation&gt;
  &lt;formset&gt;
    &lt;form name="BookForm"&gt; ... &lt;/form&gt;
    &lt;form name="BookForm"&gt; ... &lt;/form&gt;  &lt;!-- Noncompliant --&gt;
  &lt;/formset&gt;
&lt;/form-validation&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
&lt;form-validation&gt;
  &lt;formset&gt;
    &lt;form name="BookForm"&gt; ... &lt;/form&gt;
  &lt;/formset&gt;
&lt;/form-validation&gt;
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/102.html">MITRE, CWE-102</a> - Struts: Duplicate Validation Forms </li>
  <li> <a href="https://www.owasp.org/index.php/Struts:_Duplicate_Validation_Forms#Struts:_Duplicate_Validation_Forms">OWASP, Improper Data
  Validation</a> - Struts: Duplicate Validation Forms </li>
</ul>ZVULNERABILITY
•
squid:S2164ï
squidS2164&Math should not be performed on floats"MINOR*java: <p>For small numbers, <code>float</code> math has enough precision to yield the expected value, but for larger numbers, it does not.
<code>BigDecimal</code> is the best alternative, but if a primitive is required, use a <code>double</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
float a = 16777216.0f;
float b = 1.0f;
float c = a + b; // Noncompliant; yields 1.6777216E7 not 1.6777217E7

double d = a + b; // Noncompliant; addition is still between 2 floats
</pre>
<h2>Compliant Solution</h2>
<pre>
float a = 16777216.0f;
float b = 1.0f;
BigDecimal c = BigDecimal.valueOf(a).add(BigDecimal.valueOf(b));

double d = (double)a + (double)b;
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/DgU">CERT, FLP02-C.</a> - Avoid using floating-point numbers when precise computation
  is needed </li>
</ul>ZBUG
Ü
squid:S1197ˆ
squidS1197>Array designators "[]" should be on the type, not the variable"MINOR*java:å<p>Array designators should always be located on the type for better code readability. Otherwise, developers must look both at the type and the
variable name to know whether or not a variable is an array.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int matrix[][];   // Noncompliant
int[] matrix[];   // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
int[][] matrix;   // Compliant
</pre>Z
CODE_SMELL
©
squid:S2165ô
squidS2165*"finalize" should not set fields to "null""MINOR*java:√<p>There is no point in setting class fields to <code>null</code> in a finalizer. If this this is a hint to the garbage collector, it is unnecessary -
the object will be garbage collected anyway - and doing so may actually cause extra work for the garbage collector.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Foo {
  private String name;

  @Override
  void finalize() {
    name = null;  // Noncompliant; completely unnecessary
</pre>Z
CODE_SMELL
—
squid:S2162¡
squidS2162<"equals" methods should be symmetric and work for subclasses"MINOR*java:‡<p>A key facet of the <code>equals</code> contract is that if <code>a.equals(b)</code> then <code>b.equals(a)</code>, i.e. that the relationship is
symmetric. </p>
<p>Using <code>instanceof</code> breaks the contract when there are subclasses, because while the child is an <code>instanceof</code> the parent, the
parent is not an <code>instanceof</code> the child. For instance, assume that <code>Raspberry extends Fruit</code> and adds some fields (requiring a
new implementation of <code>equals</code>):</p>
<pre>
Fruit fruit = new Fruit();
Raspberry raspberry = new Raspberry();

if (raspberry instanceof Fruit) { ... } // true
if (fruit instanceof Raspberry) { ... } // false
</pre>
<p>If similar <code>instanceof</code> checks were used in the classes' <code>equals</code> methods, the symmetry principle would be broken:</p>
<pre>
raspberry.equals(fruit); // false
fruit.equals(raspberry); //true
</pre>
<p>Additionally, non <code>final</code> classes shouldn't use a hardcoded class name in the <code>equals</code> method because doing so breaks the
method for subclasses. Instead, make the comparison dynamic.</p>
<p>Further, comparing to an unrelated class type breaks the contract for that unrelated type, because while
<code>thisClass.equals(unrelatedClass)</code> can return true, <code>unrelatedClass.equals(thisClass)</code> will not.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit extends Food {
  private Season ripe;

  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }
    if (obj == null) {
      return false;
    }
    if (Fruit.class == obj.getClass()) { // Noncompliant; broken for child classes
      return ripe.equals(((Fruit)obj).getRipe());
    }
    if (obj instanceof Fruit ) {  // Noncompliant; broken for child classes
      return ripe.equals(((Fruit)obj).getRipe());
    }
    else if (obj instanceof Season) { // Noncompliant; symmetry broken for Season class
      // ...
    }
    //...
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Fruit extends Food {
  private Season ripe;

  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }
    if (obj == null) {
      return false;
    }
    if (this.getClass() == obj.getClass()) {
      return ripe.equals(((Fruit)obj).getRipe());
    }
    return false;
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/zIUbAQ">CERT, MET08-J.</a> - Preserve the equality contract when overriding the
  equals() method </li>
</ul>ZBUG
«
squid:S1195∑
squidS1195LArray designators "[]" should be located after the type in method signatures"MINOR*java:ø<p>According to the Java Language Specification: </p>
<blockquote>
  <p>For compatibility with older versions of the Java SE platform,</p>
  <p>the declaration of a method that returns an array is allowed to place (some or all of) the empty bracket pairs that form the declaration of the
  array type after the formal parameter list.</p>
  <p>This obsolescent syntax should not be used in new code.</p>
</blockquote>
<h2>Noncompliant Code Example</h2>
<pre>
public int getVector()[] { /* ... */ }    // Noncompliant

public int[] getMatrix()[] { /* ... */ }  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
public int[] getVector() { /* ... */ }

public int[][] getMatrix() { /* ... */ }
</pre>Z
CODE_SMELL
…
squid:S3373π
squidS3373<"action" mappings should not have too many "forward" entries"MINOR*java:—<p>It makes sense to handle all related actions in the same place. Thus, the same <code>&lt;action&gt;</code> might logically handle all facets of
CRUD on an entity, with no confusion in the naming about which <code>&lt;forward/&gt;</code> handles which facet. But go very far beyond that, and it
becomes difficult to maintain a transparent naming convention. </p>
<p>So to ease maintenance, this rule raises an issue when an <code>&lt;action&gt;</code> has more than the allowed number of
<code>&lt;forward/&gt;</code> tags.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold of 4:</p>
<pre>
&lt;action path='/book' type='myapp.BookDispatchAction' name='form' parameter='method'&gt;
  &lt;forward name='create' path='/WEB-INF/jsp/BookCreate.jspx' redirect='false'/&gt;
  &lt;forward name='read' path='/WEB-INF/jsp/BookDetails' redirect='false'/&gt;
  &lt;forward name='update' path='/WEB-INF/jsp/BookUpdate.jspx' redirect='false'/&gt;
  &lt;forward name='delete' path='/WEB-INF/jsp/BookDelete.jspx' redirect='false'/&gt;
  &lt;forward name='authorRead' path='WEB-INF/jsp/AuthorDetails' redirect='false'/&gt;  &lt;!-- Noncompliant --&gt;
&lt;/action&gt;
</pre>
<h2>Compliant Solution</h2>
<pre>
&lt;action path='/book' type='myapp.BookDispatchAction' name='bookForm' parameter='method'&gt;
  &lt;forward name='create' path='/WEB-INF/jsp/BookCreate.jspx' redirect='false'/&gt;
  &lt;forward name='read' path='/WEB-INF/jsp/BookDetails' redirect='false'/&gt;
  &lt;forward name='update' path='/WEB-INF/jsp/BookUpdate.jspx' redirect='false'/&gt;
  &lt;forward name='delete' path='/WEB-INF/jsp/BookDelete.jspx' redirect='false'/&gt;
&lt;/action&gt;

&lt;action path='/author' type='myapp.AuthorDispatchAction' name='authorForm' parameter='method'&gt;
  &lt;forward name='authorRead' path='WEB-INF/jsp/AuthorDetails' redirect='false'/&gt;
&lt;/action&gt;
</pre>Z
CODE_SMELL
ä
squid:S1194˙
squidS1194("java.lang.Error" should not be extended"MAJOR*java:¶<p><code>java.lang.Error</code> and its subclasses represent abnormal conditions, such as <code>OutOfMemoryError</code>, which should only be
encountered by the Java Virtual Machine.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyException extends Error { /* ... */ }       // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyException extends Exception { /* ... */ }   // Compliant
</pre>Z
CODE_SMELL
Ù
squid:S2160‰
squidS21603Subclasses that add fields should override "equals""MINOR*java:å<p>Extend a class that overrides <code>equals</code> and add fields without overriding <code>equals</code> in the subclass, and you run the risk of
non-equivalent instances of your subclass being seen as equal, because only the superclass fields will be considered in the equality test.</p>
<p>This rule looks for classes that do all of the following:</p>
<ul>
  <li> extend classes that override <code>equals</code>. </li>
  <li> do not themselves override <code>equals</code>. </li>
  <li> add fields. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit {
  private Season ripe;

  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }
    if (this.class != obj.class) {
      return false;
    }
    Fruit fobj = (Fruit) obj;
    if (ripe.equals(fobj.getRipe()) {
      return true;
    }
    return false;
  }
}

public class Raspberry extends Fruit {  // Noncompliant; instances will use Fruit's equals method
  private Color ripeColor;
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Fruit {
  private Season ripe;

  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }
    if (this.class != obj.class) {
      return false;
    }
    Fruit fobj = (Fruit) obj;
    if (ripe.equals(fobj.getRipe()) {
      return true;
    }
    return false;
  }
}

public class Raspberry extends Fruit {
  private Color ripeColor;

  public boolean equals(Object obj) {
    if (! super.equals(obj)) {
      return false;
    }
    Raspberry fobj = (Raspberry) obj;
    if (ripeColor.equals(fobj.getRipeColor()) {  // added fields are tested
      return true;
    }
    return false;
  }
}
</pre>ZBUG
Ó
squid:S1193ﬁ
squidS1193GException types should not be tested using "instanceof" in catch blocks"MAJOR*java:Î<p>Multiple catch blocks of the appropriate type should be used instead of catching a general exception, and then testing on the type.</p>
<h2>Noncompliant Code Example</h2>
<pre>
try {
  /* ... */
} catch (Exception e) {
  if(e instanceof IOException) { /* ... */ }         // Noncompliant
  if(e instanceof NullPointerException{ /* ... */ }  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
try {
  /* ... */
} catch (IOException e) { /* ... */ }                // Compliant
} catch (NullPointerException e) { /* ... */ }       // Compliant
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/5gFFB">CERT, ERR51-J.</a> - Prefer user-defined exceptions over more general exception
  types </li>
</ul>Z
CODE_SMELL
ó
squid:S1192á
squidS1192(String literals should not be duplicated"CRITICAL*java:∞
<p>Duplicated string literals make the process of refactoring error-prone, since you must be sure to update all occurrences.</p>
<p>On the other hand, constants can be referenced from many places, but only need to be updated in a single place.</p>
<h2>Noncompliant Code Example</h2>
<p>With the default threshold of 3:</p>
<pre>
public void run() {
  prepare("action1");                              // Noncompliant - "action1" is duplicated 3 times
  execute("action1");
  release("action1");
}

@SuppressWarning("all")                            // Compliant - annotations are excluded
private void method1() { /* ... */ }
@SuppressWarning("all")
private void method2() { /* ... */ }

public String method3(String a) {
  System.out.println("'" + a + "'");               // Compliant - literal "'" has less than 5 characters and is excluded
  return "";                                       // Compliant - literal "" has less than 5 characters and is excluded
}
</pre>
<h2>Compliant Solution</h2>
<pre>
private static final String ACTION_1 = "action1";  // Compliant

public void run() {
  prepare(ACTION_1);                               // Compliant
  execute(ACTION_1);
  release(ACTION_1);
}
</pre>
<h2>Exceptions</h2>
<p>To prevent generating some false-positives, literals having less than 5 characters are excluded.</p>Z
CODE_SMELL
ö
squid:S3027ä
squidS3027=String function use should be optimized for single characters"MINOR*java:®<p>An <code>indexOf</code> or <code>lastIndexOf</code> call with a single letter <code>String</code> can be made more performant by switching to a
call with a <code>char</code> argument.</p>
<h2>Noncompliant Code Example</h2>
<pre>
String myStr = "Hello World";
// ...
int pos = myStr.indexOf("W");  // Noncompliant
// ...
int otherPos = myStr.lastIndexOf("r"); // Noncompliant
// ...
</pre>
<h2>Compliant Solution</h2>
<pre>
String myStr = "Hello World";
// ...
int pos = myStr.indexOf('W');
// ...
int otherPos = myStr.lastIndexOf('r');
// ...
</pre>ZBUG
ñ
squid:S2059Ü
squidS2059G"Serializable" inner classes of "Serializable" classes should be static"MINOR*java:ì
<p>Serializing a non-<code>static</code> inner class will result in an attempt at serializing the outer class as well. If the outer class is actually
serializable, then the serialization will succeed but possibly write out far more data than was intended. </p>
<p>Making the inner class <code>static</code> (i.e. "nested") avoids this problem, therefore inner classes should be <code>static</code> if possible.
However, you should be aware that there are semantic differences between an inner class and a nested one: </p>
<ul>
  <li> an inner class can only be instantiated within the context of an instance of the outer class. </li>
  <li> a nested (<code>static</code>) class can be instantiated independently of the outer class. </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public class Raspberry implements Serializable {
  // ...

  public class Drupelet implements Serializable {  // Noncompliant; output may be too large
    // ...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Raspberry implements Serializable {
  // ...

  public static class Drupelet implements Serializable {
    // ...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/O4CpAQ">CERT, SER05-J.</a> - Do not serialize instances of inner classes </li>
</ul>Z
CODE_SMELL
Ø
squid:S2177ü
squidS2177FChild class methods named for parent class methods should be overrides"MAJOR*java:¥<p>When a method in a child class has the same signature as a method in a parent class, it is assumed to be an override. However, that's not the case
when:</p>
<ul>
  <li> the parent class method is <code>static</code> and the child class method is not. </li>
  <li> the arguments or return types of the child method are in different packages than those of the parent method. </li>
  <li> the parent class method is <code>private</code>. </li>
</ul>
<p>Typically, these things are done unintentionally; the private parent class method is overlooked, the <code>static</code> keyword in the parent
declaration is overlooked, or the wrong class is imported in the child. But if the intent is truly for the child class method to be different, then
the method should be renamed to prevent confusion. </p>
<h2>Noncompliant Code Example</h2>
<pre>
// Parent.java
import computer.Pear;
public class Parent {

  public void doSomething(Pear p) {
    //,,,
  }

  public static void doSomethingElse() {
    //...
  }
}

// Child.java
import fruit.Pear;
public class Child extends Parent {

  public void doSomething(Pear p) {  // Noncompliant; this is not an override
    // ...
  }


  public void doSomethingElse() {  // Noncompliant; parent method is static
    //...
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
// Parent.java
import computer.Pear;
public class Parent {

  public void doSomething(Pear p) {
    //,,,
  }

  public static void doSomethingElse() {
    //...
  }
}

// Child.java
import computer.Pear;  // import corrected
public class Child extends Parent {

  public void doSomething(Pear p) {  // true override (see import)
    //,,,
  }

  public static void doSomethingElse() {
    //...
  }
}
</pre>ZBUG
˚
squid:S2057Î
squidS2057/"Serializable" classes should have a version id"CRITICAL*java:ç<p>A <code>serialVersionUID</code> field is required in all <code>Serializable</code> classes. If you do not provide one, one will be calculated for
you by the compiler. The danger in not explicitly choosing the value is that when the class changes, the compiler will generate an entirely new id,
and you will be suddenly unable to deserialize (read from file) objects that were serialized with the previous version of the class.</p>
<p><code>serialVersionUID</code>'s should be declared with all of these modifiers: <code>static final long</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Raspberry extends Fruit  // Noncompliant; no serialVersionUID.
        implements Serializable {
  private String variety;

  public Raspberry(Season ripe, String variety) { ...}
  public void setVariety(String variety) {...}
  public String getVarity() {...}
}

public class Raspberry extends Fruit
        implements Serializable {
  private final int serialVersionUID = 1; // Noncompliant; not static &amp; int rather than long
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Raspberry extends Fruit
        implements Serializable {
  private static final long serialVersionUID = 1;
  private String variety;

  public Raspberry(Season ripe, String variety) { ...}
  public void setVariety(String variety) {...}
  public String getVarity() {...}
}
</pre>
<h2>Exceptions</h2>
<p>Swing and AWT classes, <code>abstract</code> classes, <code>Throwable</code> and its subclasses (<code>Exception</code>s and <code>Error</code>s),
and classes marked with <code>@SuppressWarnings("serial")</code> are ignored.</p>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/NYCpAQ">CERT, SER00-J.</a> - Enable serialization compatibility during class evolution
  </li>
</ul>Z
CODE_SMELL
ø
squid:S2178Ø
squidS21786Short-circuit logic should be used in boolean contexts"MAJOR*java:‘<p>The use of non-short-circuit logic in a boolean context is likely a mistake - one that could cause serious program errors as conditions are
evaluated under the wrong circumstances.</p>
<h2>Noncompliant Code Example</h2>
<pre>
if(getTrue() | getFalse()) { ... } // Noncompliant; both sides evaluated
</pre>
<h2>Compliant Solution</h2>
<pre>
if(getTrue() || getFalse()) { ... }  // true short-circuit logic
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/g4FtAg">CERT, EXP46-C.</a> - Do not use a bitwise operator with a Boolean-like operand
  </li>
</ul>ZBUG
ˇ
squid:S2175Ô
squidS21753Inappropriate "Collection" calls should not be made"MAJOR*java:ó<p>A couple <code>Collection</code> methods can be called with arguments of an incorrect type, but doing so is pointless and likely the result of
using the wrong argument. This rule will raise an issue when the type of the argument to <code>List.contains</code> or <code>List.remove</code> is
unrelated to the type used for the list declaration.</p>
<h2>Noncompliant Code Example</h2>
<pre>
List&lt;String&gt; list = new ArrayList&lt;String&gt;();
Integer integer = Integer.valueOf(1);

if (list.contains(integer)) {  // Noncompliant. Always false.
  list.remove(integer); // Noncompliant. list.add(integer) doesn't compile, so this will always return false
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/QwFlAQ">CERT, EXP04-J.</a> - Do not pass arguments to certain Java Collections
  Framework methods that are a different type than the collection parameter type </li>
</ul>ZBUG
§
squid:S2176î
squidS21768Class names should not shadow interfaces or superclasses"CRITICAL*java:≠<p>While it's perfectly legal to give a class the same simple name as a class in another package that it extends or interface it implements, it's
confusing and could cause problems in the future. </p>
<h2>Noncompliant Code Example</h2>
<pre>
package my.mypackage;

public class Foo implements a.b.Foo { // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
package my.mypackage;

public class FooJr implements a.b.Foo {
</pre>Z
CODE_SMELL
Ê
squid:S2055÷
squidS2055`The non-serializable super class of a "Serializable" class should have a no-argument constructor"MINOR*java:—<p>When a <code>Serializable</code> object has a non-serializable ancestor in its inheritance chain, object deserialization (re-instantiating the
object from file) starts at the first non-serializable class, and proceeds down the chain, adding the properties of each subsequent child class, until
the final object has been instantiated. </p>
<p>In order to create the non-serializable ancestor, its no-argument constructor is called. Therefore the non-serializable ancestor of a
<code>Serializable</code> class must have a no-arg constructor. Otherwise the class is <code>Serializable</code> but not deserializable.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Fruit {
  private Season ripe;

  public Fruit (Season ripe) {...}
  public void setRipe(Season ripe) {...}
  public Season getRipe() {...}
}

public class Raspberry extends Fruit
        implements Serializable {  // Noncompliant; nonserializable ancestor doesn't have no-arg constructor
  private static final long serialVersionUID = 1;

  private String variety;

  public Raspberry(Season ripe, String variety) { ...}
  public void setVariety(String variety) {...}
  public String getVarity() {...}
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class Fruit {
  private Season ripe;

  public Fruit () {...};  // Compliant; no-arg constructor added to ancestor
  public Fruit (Season ripe) {...}
  public void setRipe(Season ripe) {...}
  public Season getRipe() {...}
}

public class Raspberry extends Fruit
        implements Serializable {
  private static final long serialVersionUID = 1;

  private String variety;

  public Raspberry(Season ripe, String variety) {...}
  public void setVariety(String variety) {...}
  public String getVarity() {...}
}
</pre>ZBUG
¥	
2squid:RightCurlyBraceDifferentLineAsNextBlockCheck˝
squid,RightCurlyBraceDifferentLineAsNextBlockCheckfClose curly brace and the next "else", "catch" and "finally" keywords should be on two different lines"MINOR*java2S1108:Ω<p>Shared coding conventions make it possible for a team to collaborate efficiently.</p>
<p>This rule makes it mandatory to place a closing curly brace and the next <code>else</code>, <code>catch</code> or <code>finally</code> keyword on
two different lines.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void myMethod() {
  if(something) {
    executeTask();
  } else if (somethingElse) {          // Noncompliant
    doSomethingElse();
  }
  else {                               // Compliant
     generateError();
  }

  try {
    generateOrder();
  } catch (Exception e) {
    log(e);
  }
  finally {
    closeConnection();
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void myMethod() {
  if(something) {
    executeTask();
  }
  else if (somethingElse) {
    doSomethingElse();
  }
  else {
     generateError();
  }

  try {
    generateOrder();
  }
  catch (Exception e) {
    log(e);
  }
  finally {
    closeConnection();
  }
}
</pre>Z
CODE_SMELL
ó
"squid:ClassVariableVisibilityCheck
squidClassVariableVisibilityCheck:Class variable fields should not have public accessibility"MINOR*java2S1104:È
<p>Public class variable fields do not respect the encapsulation principle and has three main disadvantages:</p>
<ul>
  <li> Additional behavior such as validation cannot be added. </li>
  <li> The internal representation is exposed, and cannot be changed afterwards. </li>
  <li> Member values are subject to change from anywhere in the code and may not meet the programmer's assumptions. </li>
</ul>
<p>By using private attributes and accessor methods (set and get), unauthorized modifications are prevented.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  public static final int SOME_CONSTANT = 0;     // Compliant - constants are not checked

  public String firstName;                       // Noncompliant

}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {

  public static final int SOME_CONSTANT = 0;     // Compliant - constants are not checked

  private String firstName;                      // Compliant

  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

}
</pre>
<h2>Exceptions</h2>
<p>Because they are not modifiable, this rule ignores <code>public final</code> fields.</p>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/493.html">MITRE, CWE-493</a> - Critical Public Variable Without Final Modifier </li>
</ul>ZVULNERABILITY
≠
"squid:LeftCurlyBraceStartLineCheckÜ
squidLeftCurlyBraceStartLineCheck@An open curly brace should be located at the beginning of a line"MINOR*java2S1106:¸<p>Shared coding conventions make it possible to collaborate efficiently. This rule makes it mandatory to place the open curly brace at the beginning
of a line.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public void myMethod {  // Noncompliant
  if(something) {  // Noncompliant
    executeTask();
  } else {  // Noncompliant
    doSomethingElse();
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void myMethod
{
  if(something)
  {
    executeTask();
  } else
  {
    doSomethingElse();
  }
}
</pre>Z
CODE_SMELL
⁄
squid:S3020 
squidS30206"toArray" should be passed an array of the proper type"MINOR*java:Ô<p>Given no arguments, the <code>Collections.toArray</code> method returns an <code>Object []</code>, which will cause a
<code>ClassCastException</code> at runtime if you try to cast it to an array of the proper class. Instead, pass an array of the correct type in to the
call.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public String [] getStringArray(List&lt;String&gt; strings) {
  return (String []) strings.toArray();  // Noncompliant; ClassCastException thrown
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public String [] getStringArray(List&lt;String&gt; strings) {
  return strings.toArray(new String[0]);
}
</pre>ZBUG
ﬁ
squid:S2293Œ
squidS2293*The diamond operator ("<>") should be used"MINOR*java:¯<p>Java 7 introduced the diamond operator (<code>&lt;&gt;</code>) to reduce the verbosity of generics code. For instance, instead of having to declare
a <code>List</code>'s type in both its declaration and its constructor, you can now simplify the constructor declaration with <code>&lt;&gt;</code>,
and the compiler will infer the type.</p>
<p><strong>Note</strong> that this rule is automatically disabled when the project's <code>sonar.java.source</code> is lower than <code>7</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
List&lt;String&gt; strings = new ArrayList&lt;String&gt;();  // Noncompliant
Map&lt;String,List&lt;Integer&gt;&gt; map = new HashMap&lt;String,List&lt;Integer&gt;&gt;();  // Noncompliant
</pre>
<h2>Compliant Solution</h2>
<pre>
List&lt;String&gt; strings = new ArrayList&lt;&gt;();
Map&lt;String,List&lt;Integer&gt;&gt; map = new HashMap&lt;&gt;();
</pre>Z
CODE_SMELL
«
%squid:RedundantThrowsDeclarationCheckù
squidRedundantThrowsDeclarationCheck/"throws" declarations should not be superfluous"MINOR*java2S1130:°<p>An exception in a <code>throws</code> declaration in Java is superfluous if it is:</p>
<ul>
  <li> listed multiple times </li>
  <li> a subclass of another listed exception </li>
  <li> a <code>RuntimeException</code>, or one of its descendants </li>
  <li> completely unnecessary because the declared exception type cannot actually be thrown </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
void foo() throws MyException, MyException {}  // Noncompliant; should be listed once
void bar() throws Throwable, Exception {}  // Noncompliant; Exception is a subclass of Throwable
void baz() throws RuntimeException {}  // Noncompliant; RuntimeException can always be thrown
</pre>
<h2>Compliant Solution</h2>
<pre>
void foo() throws MyException {}
void bar() throws Throwable {}
void baz() {}
</pre>Z
CODE_SMELL
Õ
squid:TrailingCommentCheckÆ
squidTrailingCommentCheck:Comments should not be located at the end of lines of code"MINOR*java2S139:≥<p>This rule verifies that single-line comments are not located at the ends of lines of code. The main idea behind this rule is that in order to be
really readable, trailing comments would have to be properly written and formatted (correct alignment, no interference with the visual structure of
the code, not too long to be visible) but most often, automatic code formatters would not handle this correctly: the code would end up less readable.
Comments are far better placed on the previous empty line of code, where they will always be visible and properly formatted.</p>
<h2>Noncompliant Code Example</h2>
<pre>
int a1 = b + c; // This is a trailing comment that can be very very long
</pre>
<h2>Compliant Solution</h2>
<pre>
// This very long comment is better placed before the line of code
int a2 = b + c;
</pre>Z
CODE_SMELL
·

squid:S2089—

squidS2089%HTTP referers should not be relied on"CRITICAL*java:˙	<p>The fields in an HTTP request are putty in the hands of an attacker, and you cannot rely on them to tell you the truth about anything. While it may
be safe to store such values after they have been neutralized, decisions should never be made based on their contents.</p>
<p>This rule flags uses of the referer header field.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyServlet extends HttpServlet {
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String referer = request.getHeader("referer");  // Noncompliant
    if(isTrustedReferer(referer)){
      //..
    }
    //...
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/807">MITRE, CWE-807</a> - Reliance on Untrusted Inputs in a Security Decision </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/293">MITRE, CWE-293</a> - Using Referer Field for Authentication </li>
  <li> <a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Porous Defenses </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management">OWASP Top Ten 2013 Category A2</a> -
  Broken Authentication and Session Management </li>
</ul>ZVULNERABILITY
™
squid:S3052ö
squidS30522Fields should not be initialized to default values"MINOR*java:º<p>The compiler automatically initializes class fields to their default values before setting them with any initialization values, so there is no need
to explicitly set a field to its default value. Further, under the logic that cleaner code is better code, it's considered poor style to do so.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {

  int count = 0;  // Noncompliant
  // ...

}
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {

  int count;
  // ...

}
</pre>
<h2>Exceptions</h2>
<p><code>final</code> fields are ignored.</p>Z
CODE_SMELL
Œ

squid:S888ø
squidS888JEquality operators should not be used in "for" loop termination conditions"CRITICAL*java:«<p>Testing <code>for</code> loop termination using an equality operator (<code>==</code> and <code>!=</code>) is dangerous, because it could set up an
infinite loop. Using a broader relational operator instead casts a wider net, and makes it harder (but not impossible) to accidentally write an
infinite loop.</p>
<h2>Noncompliant Code Example</h2>
<pre>
for (int i = 1; i != 10; i += 2)  // Noncompliant. Infinite; i goes from 9 straight to 11.
{
  //...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
for (int i = 1; i &lt;= 10; i += 2)  // Compliant
{
  //...
}
</pre>
<h2>Exceptions</h2>
<p>Equality operators are ignored if the loop counter is not modified within the body of the loop and either:</p>
<ul>
  <li> starts below the ending value and is incremented by 1 on each iteration. </li>
  <li> starts above the ending value and is decremented by 1 on each iteration. </li>
</ul>
<p>Equality operators are also ignored when the test is against <code>null</code>.</p>
<pre>
for (int i = 0; arr[i] != null; i++) {
  // ...
}

for (int i = 0; (item = arr[i]) != null; i++) {
  // ...
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C++:2008, 6-5-2 </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/835">MITRE, CWE-835</a> - Loop with Unreachable Exit Condition ('Infinite Loop') </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/EwDJAQ">CERT, MSC21-C.</a> - Use robust loop termination conditions </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/GwDJAQ">CERT, MSC21-CPP.</a> - Use inequality to terminate a loop whose counter changes
  by more than one </li>
</ul>Z
CODE_SMELL
æ
squid:ModifiersOrderCheck†
squidModifiersOrderCheck1Modifiers should be declared in the correct order"MINOR*java2S1124:Æ<p>The Java Language Specification recommends listing modifiers in the following order:</p>
<p>1. Annotations</p>
<p>2. public</p>
<p>3. protected</p>
<p>4. private</p>
<p>5. abstract</p>
<p>6. static</p>
<p>7. final</p>
<p>8. transient</p>
<p>9. volatile</p>
<p>10. synchronized</p>
<p>11. native</p>
<p>12. strictfp</p>
<p>Not following this convention has no technical impact, but will reduce the code's readability because most developers are used to the standard
order.</p>
<h2>Noncompliant Code Example</h2>
<pre>
static public void main(String[] args) {   // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public static void main(String[] args) {   // Compliant
}
</pre>Z
CODE_SMELL
÷
squid:S3066∆
squidS3066,"enum" fields should not be publicly mutable"MINOR*java:Î<p><code>enum</code>s are generally thought of as constant, but an <code>enum</code> with a <code>public</code> field or <code>public</code> setter is
not only non-constant, but also vulnerable to malicious code. Ideally fields in an <code>enum</code> are <code>private</code> and set in the
constructor, but if that's not possible, their visibility should be reduced as much as possible.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public enum Continent {

  NORTH_AMERICA (23, 24709000),
  // ...
  EUROPE (50, 39310000);

  public int countryCount;  // Noncompliant
  private int landMass;

  Continent(int countryCount, int landMass) {
    // ...
  }

  public void setLandMass(int landMass) {  // Noncompliant
    this.landMass = landMass;
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
public enum Continent {

  NORTH_AMERICA (23, 24709000),
  // ...
  EUROPE (50, 39310000);

  private int countryCount;
  private int landMass;

  Continent(int countryCount, int landMass) {
    // ...
  }
</pre>ZVULNERABILITY
ï
squid:S3067Ö
squidS30671"getClass" should not be used for synchronization"MAJOR*java:Ø<p><code>getClass</code> should not be used for synchronization in non-<code>final</code> classes because child classes will synchronize on a
different object than the parent or each other, allowing multiple threads into the code block at once, despite the <code>synchronized</code>
keyword.</p>
<p>Instead, hard code the name of the class on which to synchronize or make the class <code>final</code>.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class MyClass {
  public void doSomethingSynchronized(){
    synchronized (this.getClass()) {  // Noncompliant
      // ...
    }
  }
</pre>
<h2>Compliant Solution</h2>
<pre>
public class MyClass {
  public void doSomethingSynchronized(){
    synchronized (MyClass.class) {
      // ...
    }
  }
</pre>
<h2>See</h2>
<ul>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/bwCaAg">CERT, LCK02-J.</a> - Do not synchronize on the class object returned by
  getClass() </li>
</ul>ZBUG
Ö
squid:S2096ı
squidS2096""main" should not "throw" anything"BLOCKER*java:¨<p>There's no reason for a <code>main</code> method to <code>throw</code> anything. After all, what's going to catch it? </p>
<p>Instead, the method should itself gracefully handle any exceptions that may bubble up to it, attach as much contextual information as possible, and
perform whatever logging or user communication is necessary, and <code>exit</code> with non-zero (i.e. non-success) exit code if necessary.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public static void main(String args[]) throws Exception { // Noncompliant
  doSomething();
</pre>
<h2>Compliant Solution</h2>
<pre>
public static void main(String args[]) {
 try {
    doSomething();
  } catch (Throwable t) {
    log.error(t);
    System.exit(1);  // Default exit code, 0, indicates success. Non-zero value means failure.
  }
}
</pre>ZBUG
—
squid:S2097¡
squidS2097."equals(Object obj)" should test argument type"MINOR*java:Ó<p>Because the <code>equals</code> method takes a generic <code>Object</code> as a parameter, any type of object may be passed to it. The method
should not assume it will only be used to test objects of its class type. It must instead check the parameter's type.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public boolean equals(Object obj) {
  MyClass mc = (MyClass)obj;  // Noncompliant
  // ...
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public boolean equals(Object obj) {
  if (obj == null)
    return false;

  if (this.getClass() != obj.getClass())
    return false;

  MyClass mc = (MyClass)obj;
  // ...
}
</pre>ZBUG
ê
squid:S2094Ä
squidS2094Classes should not be empty"MINOR*java:π<p>There is no good excuse for an empty class. If it's being used simply as a common extension point, it should be replaced with an
<code>interface</code>. If it was stubbed in as a placeholder for future development it should be fleshed-out. In any other case, it should be
eliminated.</p>
<h2>Noncompliant Code Example</h2>
<pre>
public class Nothing {  // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public interface Nothing {
}
</pre>
<h2>Exceptions</h2>
<p>Empty classes can be used as marker types (for Spring for instance), therefore empty classes that are annotated will be ignored.</p>
<pre>
@Configuration
@EnableWebMvc
public final class ApplicationConfiguration {

}
</pre>Z
CODE_SMELL
ñ
squid:S2095Ü
squidS2095Resources should be closed"BLOCKER*java:≈<p>Java's garbage collection cannot be relied on to clean up everything. Specifically, connections, streams, files and other classes that implement
the <code>Closeable</code> interface or its super-interface, <code>AutoCloseable</code>, must be manually closed after creation. Further, that
<code>close</code> call must be made in a <code>finally</code> block, otherwise an exception could keep the call from being made. </p>
<p>Failure to properly close resources will result in a resource leak which could bring first the application and then perhaps the box it's on to
their knees.</p>
<h2>Noncompliant Code Example</h2>
<pre>
private void readTheFile() throws IOException {
  Path path = Paths.get(this.fileName);
  BufferedReader reader = Files.newBufferedReader(path, this.charset)) {
  // ...
  reader.close();  // Noncompliant
}

private void doSomething() {
  OutputStream stream = null;
  try {
    for (String property : propertyList) {
      stream = new FileOutputStream("myfile.txt");  // Noncompliant
      // ...
    }
  } catch (Exception e) {
    // ...
  } finally {
    stream.close();  // Multiple streams were opened. Only the last is closed.
  }
}
</pre>
<h2>Compliant Solution</h2>
<pre>
private void readTheFile() throws IOException {
  Path path = Paths.get(this.fileName);
  BufferedReader reader = null;
  try {
    reader = Files.newBufferedReader(path, this.charset)) {
    // ...
  } finally {
    if (reader != null) {
      reader.close();
    }
  }
}

private void doSomething() {
  OutputStream stream = null;
  try {
    stream = new FileOutputStream("myfile.txt");
    for (String property : propertyList) {
      // ...
    }
  } catch (Exception e) {
    // ...
  } finally {
    stream.close();
  }
}
</pre>
<h2>Exceptions</h2>
<p>Java 7 introduced the try-with-resources statement, which implicitly closes <code>Closeables</code>. All resources opened in a try-with-resources
statement are ignored by this rule. </p>
<pre>
try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
  //...
}
catch ( ... ) {
  //...
}
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/459.html">MITRE, CWE-459</a> - Incomplete Cleanup </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9gFqAQ">CERT, FIO04-J.</a> - Release resources when they are no longer needed </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/GAGQBw">CERT, FIO42-C.</a> - Close files when they are no longer needed </li>
</ul>ZBUG
©

squid:S899ö
squidS899OReturn values should not be ignored when they contain the operation status code"MINOR*java:ù<p>When the return value of a function call contain the operation status code, this value should be tested to make sure the operation completed
successfully.</p>
<p>This rule raises an issue when the return values of the following are ignored:</p>
<ul>
  <li> <code>java.io.File</code> operations that return a status code (except <code>mkdirs</code>) </li>
  <li> <code>Iterator.hasNext()</code> </li>
  <li> <code>Enumeration.hasMoreElements()</code> </li>
  <li> <code>Lock.tryLock()</code> </li>
  <li> non-void <code>Condition.await*</code> methods </li>
  <li> <code>CountDownLatch.await(long, TimeUnit)</code> </li>
  <li> <code>Semaphore.tryAcquire</code> </li>
  <li> <code>BlockingQueue</code>: <code>offer</code>, <code>remove</code>, <code>drainTo</code>, </li>
</ul>
<h2>Noncompliant Code Example</h2>
<pre>
public void doSomething(File file, Lock lock) {
  file.delete();  // Noncompliant
  // ...
  lock.tryLock(); // Noncompliant
}
</pre>
<h2>Compliant Solution</h2>
<pre>
public void doSomething(File file, Lock lock) {
  if (!lock.tryLock()) {
    // lock failed; take appropriate action
  }
  if (!file.delete()) {
    // file delete failed; take appropriate action
  }
}
</pre>
<h2>See</h2>
<ul>
  <li> MISRA C:2004, 16.10 - If a function returns error information, then that error information shall be tested </li>
  <li> MISRA C++:2008, 0-1-7 - The value returned by a function having a non-void return type that is not an overloaded operator shall always be used.
  </li>
  <li> MISRA C:2012, Dir. 4.7 - If a function returns error information, then that error information shall be tested </li>
  <li> MISRA C:2012, 17.7 - The value returned by a function having non-void return type shall be used </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/w4C4Ag">CERT, ERR33-C.</a> - Detect and handle standard library errors </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/iIBfBw">CERT, POS54-C.</a> - Detect and handle POSIX library errors </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9gEqAQ">CERT, EXP00-J.</a> - Do not ignore values returned by methods </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/9YIRAQ">CERT, EXP12-C.</a> - Do not ignore values returned by functions </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/eoAyAQ">CERT, EXP12-CPP.</a> - Do not ignore values returned by functions or methods
  </li>
  <li> <a href="https://www.securecoding.cert.org/confluence/x/toHWAw">CERT, FIO02-J.</a> - Detect and handle file-related errors </li>
  <li> <a href="http://cwe.mitre.org/data/definitions/754">MITRE, CWE-754</a> - Improper Check for Unusual Exceptional Conditions </li>
</ul>ZVULNERABILITY
Á
squid:S2092◊
squidS2092Cookies should be "secure""MINOR*java:é<p>The "secure" attribute prevents cookies from being sent over plaintext connections such as HTTP, where they would be easily eavesdropped upon.
Instead, cookies with the secure attribute are only sent over encrypted HTTPS connections.</p>
<h2>Noncompliant Code Example</h2>
<pre>
Cookie c = new Cookie(SECRET, secret);  // Noncompliant; cookie is not secure
response.addCookie(c);
</pre>
<h2>Compliant Solution</h2>
<pre>
Cookie c = new Cookie(SECRET, secret);
c.setSecure(true);
response.addCookie(c);
</pre>
<h2>See</h2>
<ul>
  <li> <a href="http://cwe.mitre.org/data/definitions/614">MITRE, CWE-614</a> - Sensitive Cookie in HTTPS Session Without 'Secure' Attribute </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management">OWASP Top Ten 2013 Category A2</a> -
  Broken Authentication and Session Management </li>
  <li> <a href="https://www.owasp.org/index.php/Top_10_2013-A6-Sensitive_Data_Exposure">OWASP Top Ten 2013 Category A6</a> - Sensitive Data Exposure
  </li>
</ul>ZVULNERABILITY
õ

0sonarscanner:sonar-scanner-deprecated-propertiesÊ	
sonarscanner#sonar-scanner-deprecated-properties2Deprecated SonarQube properties should not be used"MAJOR*jproperties:‹<p>The following SonarQube properties are deprecated and should no longer be used:</p>
<ul>
    <li><code>sonar.profile</code>: This property should be removed.</li>
    <li><code>sonar.skipDesign</code>: This property should be removed.</li>
    <li><code>sonar.showProfiling</code>: <code>sonar.log.level</code> should be used instead.</li>
    <li><code>sonar.binaries</code>: <code>sonar.java.binaries</code> should be used instead.</li>
    <li><code>sonar.libraries</code>: <code>sonar.java.libraries</code> should be used instead.</li>
</ul>

<h2>Noncompliant Code Example</h2>
<pre>
sonar.libraries=lib
sonar.binaries=bin
sonar.skipDesign=true
sonar.profile=myprofile
sonar.showProfiling=true
</pre>

<h2>Compliant Solution</h2>
<pre>
sonar.java.libraries=lib
sonar.java.binaries=bin
sonar.log.level=DEBUG
</pre>

<h2>See</h2>
<ul>
    <li><a href="http://docs.sonarqube.org/display/SONAR/Analysis+Parameters">SonarQube analysis parameters documentation</a></li>
    <li><a href="http://docs.sonarqube.org/display/PLUG/Java+Plugin+and+Bytecode">SonarQube Java Plugin and Bytecode documentation</a></li>
</ul>Z
CODE_SMELL
À
*OWASP:UsingComponentWithKnownVulnerabilityú
OWASP$UsingComponentWithKnownVulnerability+Using Components with Known Vulnerabilities"MAJOR*neutral:†<p>Components, such as libraries, frameworks, and other software modules, almost always run with full privileges. If a vulnerable component is exploited, such an attack can facilitate serious data loss or server takeover. Applications using components with known vulnerabilities may undermine application defenses and enable a range of possible attacks and impacts.</p><h3>References:</h3><ul><li>OWASP Top 10 2013-A9: <a href="https://www.owasp.org/index.php/Top_10_2013-A9-Using_Components_with_Known_Vulnerabilities">Using Components with Known Vulnerabilities</a></li><li><a href="https://cwe.mitre.org/data/definitions/937.html">Common Weakness Enumeration CWE-937</a></li><p>This issue was generated by <a href="https://www.owasp.org/index.php/OWASP_Dependency_Check">OWASP Dependency-Check</a>ZVULNERABILITY
«
"common-jproperties:FailedUnitTests†
common-jpropertiesFailedUnitTests!Failed unit tests should be fixed"MAJOR*jproperties:ºTest failures or errors generally indicate that regressions have been introduced. Those tests should be handled as soon as possible to reduce the cost to fix the corresponding regressions.ZBUG
§
#common-jproperties:SkippedUnitTests¸
common-jpropertiesSkippedUnitTests4Skipped unit tests should be either removed or fixed"MAJOR*jproperties:~Skipped unit tests are considered as dead code. Either they should be activated again (and updated) or they should be removed.Z
CODE_SMELL
à
#common-jproperties:DuplicatedBlocks‡
common-jpropertiesDuplicatedBlocks2Source files should not have any duplicated blocks"MAJOR*jproperties:dAn issue is created on a file as soon as there is at least one block of duplicated code on this fileZ
CODE_SMELL
≤
-common-jproperties:InsufficientCommentDensityÄ
common-jpropertiesInsufficientCommentDensity>Source files should have a sufficient density of comment lines"MAJOR*jproperties:ÌAn issue is created on a file as soon as the density of comment lines on this file is less than the required threshold. The number of comment lines to be written in order to reach the required threshold is provided by each issue message.Z
CODE_SMELL
˜
+common-jproperties:InsufficientLineCoverage«
common-jpropertiesInsufficientLineCoverage3Lines should have sufficient coverage by unit tests"MAJOR*jproperties:¡An issue is created on a file as soon as the line coverage on this file is less than the required threshold. It gives the number of lines to be covered in order to reach the required threshold.Z
CODE_SMELL
Ç
-common-jproperties:InsufficientBranchCoverage–
common-jpropertiesInsufficientBranchCoverage6Branches should have sufficient coverage by unit tests"MAJOR*jproperties:≈An issue is created on a file as soon as the branch coverage on this file is less than the required threshold.It gives the number of branches to be covered in order to reach the required threshold.Z
CODE_SMELL
õ
jproperties:S1135Ö
jpropertiesS1135"TODO" tags should be handled"INFO*jproperties:∞<p>
    <code>TODO</code> tags are commonly used to mark places where some more code is required, but which the developer
    wants to implement later. Sometimes the developer will not have the time or will simply forget to get back to that
    tag. This rule is meant to track those tags, and ensure that they do not go unnoticed.
</p>

<h2>Noncompliant Code Example</h2>
<pre>
# TODO: blabla
key1=value1

! TODO
key2=value2
</pre>Z
CODE_SMELL
ƒ
"jproperties:empty-line-end-of-fileù
jpropertiesempty-line-end-of-file1Files should contain an empty new line at the end"MINOR*jproperties:¢<p>Some tools such as Git work better when files end with an empty line.</p>
<p>This rule simply generates an issue if it is missing.</p>
<p>For example, a Git diff looks like:</p>
<pre>
+key=abc
\ No newline at end of file
</pre>
<p>if the empty line is missing at the end of the file.</p>Z
CODE_SMELL
ó
jproperties:S1134Å
jpropertiesS1134"FIXME" tags should be handled"INFO*jproperties:´<p>
    <code>FIXME</code> tags are commonly used to mark places where a bug is suspected, but which the developer wants to
    deal with later. Sometimes the developer will not have the time or will simply forget to get back to that tag. This
    rule is meant to track those tags, and ensure that they do not go unnoticed.
</p>

<h2>Noncompliant Code Example</h2>
<pre>
# FIXME: blabla
key1=value1

! FIXME
key2=value2
</pre>Z
CODE_SMELL
∫
 jproperties:separator-conventionï
jpropertiesseparator-convention%Separators should follow a convention"MINOR*jproperties:®<p>For readability reasons, the same separator should be used all the time.</p>
<p>Rule can be configured to check one of the following formats:
<ul>
    <li>key=value (no whitespace before and after the equals sign)</li>
    <li>key: value (one single whitespace after the equals sign)</li>
</ul>
</p>

<h2>Noncompliant Code Example</h2>
With format "key: value":
<pre>
key1=value1
key2 : value2
key3 :value3
key4:    value4
</pre>

<h2>Compliant Solution</h2>
With format "key: value":
<pre>
key1: value1
key2: value2
key3: value3
key4: value4
</pre>Z
CODE_SMELL
Ì
+jproperties:missing-translations-in-defaultΩ
jpropertiesmissing-translations-in-default?Missing translations should be added to default resource bundle"MAJOR*jproperties:≤<p>
    This rule raises an issue each time a translation key is defined in a locale resource bundle but not in the default
    resource bundle.
</p>

<h2>Noncompliant Code Example</h2>

<i>messages.properties</i>
<pre>
# Noncompliant: "farewell" property is missing
greetings: Hello
inquiry: How are you?
</pre>

<i>message_fr_FR.properties</i>
<pre>
greetings: Bonjour
farewell: Au revoir
inquiry: Comment allez-vous ?
</pre>

<h2>Compliant Solution</h2>

<i>messages.properties</i>
<pre>
greetings: Hello
farewell: Goodbye
inquiry: How are you?
</pre>

<i>message_fr_FR.properties</i>
<pre>
greetings: Bonjour
farewell: Au revoir
inquiry: Comment allez-vous ?
</pre>

<h2>See also</h2>
<ul>
    <li>Related rule <a href='/coding_rules#rule_key=jproperties%3Amissing-translations'>missing-translations</a></li>
</ul>ZBUG
‹

jproperties:S2068∆

jpropertiesS2068$Credentials should not be hard-coded"CRITICAL*jproperties:„	<p>
    Because it is easy to extract strings from a compiled application, credentials should never be hard-coded. Do so,
    and they're almost guaranteed to end up in the hands of an attacker. This is particularly true for applications that
    are distributed.
</p>
<p>
    Credentials should be stored outside of the code in a strongly-protected encrypted configuration file or database.
    This rule flags instances of hard-coded credentials. It checks for keys containing <code>login</code>,
    <code>username</code>, <code>password</code>, <code>passwd</code> or <code>pwd</code>.
</p>

<h2>Noncompliant Code Example</h2>
<pre>
db_username=myusername
db_passwd=mypassword
</pre>

<h2>See</h2>
<ul>
    <li><a href="http://cwe.mitre.org/data/definitions/798">MITRE, CWE-798</a> - Use of Hard-coded Credentials</li>
    <li><a href="http://cwe.mitre.org/data/definitions/259">MITRE, CWE-259</a> - Use of Hard-coded Password</li>
    <li><a href="http://www.sans.org/top25-software-errors/">SANS Top 25</a> - Porous Defenses</li>
    <li><a href="https://www.owasp.org/index.php/Top_10_2013-A2-Broken_Authentication_and_Session_Management">OWASP Top
        Ten 2013 Category A2</a> - Broken Authentication and Session Management
    </li>
</ul>ZVULNERABILITY
’
jproperties:commented-out-code≤
jpropertiescommented-out-code,Sections of code should not be commented out"MAJOR*jproperties:¿<p>Programmers should not comment out code as it bloats programs and reduces readability.</p>
<p>Unused code should be deleted and can be retrieved from source control history if required.</p>Z
CODE_SMELL
ﬂ
jproperties:comment-conventionº
jpropertiescomment-convention-All comments should be formatted consistently"MINOR*jproperties:…<p>For readability reasons, the same starting token should be used for each comment line. Rule can be configured to use either <code>!</code> or <code>#</code></p>
<p>This starting token should also be followed with a whitespace.</p>

<h2>Noncompliant Code Example</h2>
With token "#":
<pre>
! My comments...
! My comments...
#My comments...
</pre>

<h2>Compliant Solution</h2>
With token "#":
<pre>
# My comments...
# My comments...
# My comments...
</pre>Z
CODE_SMELL
◊
"jproperties:key-regular-expression∞
jpropertieskey-regular-expressionRegular expression on key"MAJOR*jproperties:À<p>
    This rule template can be used to create rules which will be triggered when a key matches a given regular
    expression.
</p>
<p>
    For example, one can create a rule with the regular expression "<code>^mykey.*</code>" to match all keys starting
    with 'mykey'.
</p>
<p>
    See <a target="_blank" href="http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html">Java
    documentation</a> for detailed regular expression syntax.
</p>@Z
CODE_SMELL
√
(jproperties:duplicated-keys-across-filesñ
jpropertiesduplicated-keys-across-files.Duplicated keys across files should be removed"CRITICAL*jproperties:ú<p>
    Defining several times the same key across files may be error prone. Thus, you should carefully review those
    cross-file duplicated keys and merge them whenever possible.
</p>
<p>
    Note that i18n files are excluded from being checked for cross-file duplicated keys.
</p>ZBUG
∆	
jproperties:duplicated-values§	
jpropertiesduplicated-values5Different keys having the same value should be merged"MAJOR*jproperties:™<p>
    Defining several keys holding the same value may be confusing. It may also lead to issues when one key's value is
    changed but not the others'. Thus, you should check those keys and merge them if it makes sense.
</p>
<p>
    Note that this check may be valuable for properties files containing keys internationalizing your web interface but
    might not for framework configuration files for example. Thus, you might want to precisely define the scope of this
    rule. See <a href="http://docs.sonarqube.org/display/SONAR/Narrowing+the+Focus#NarrowingtheFocus-IgnoreIssues">exclusions</a>.
</p>

<h2>Noncompliant Code Example</h2>
<p>Those three keys hold the same value:</p>
<pre>
description=SonarQube is an open platform to manage code quality. As such, it covers the 7 axes of code quality.
sonarqube.description=SonarQube is an open platform to manage code quality. As such, it covers the 7 axes of code quality.
sonarqube.details=SonarQube is an open platform to manage code quality. \
        As such, it covers the 7 axes of code quality.
</pre>Z
CODE_SMELL
˛
jproperties:S1578Ë
jpropertiesS15781File names should comply with a naming convention"MINOR*jproperties:˛<p>
    Shared coding conventions allow teams to collaborate effectively. This rule checks that all file names match a
    provided regular expression.
</p>
<p>
    As Java properties files are used in a large variety of ways and by many frameworks, it might sometimes be tricky to
    enforce a
    strict file naming convention. However, the default regular expression has been designed to match as closely as
    possible the
    following guidelines:
</p>
<ul>
    <li>Suffix files with <code>.properties</code></li>
    <li>Only use letters, digits, '_' and '-' characters</li>
    <li>Refrain from using '_' and '-' characters. Only use them when mandatory such as in i18n Java resource bundles.
    </li>
    <li>Extensively use Camel Case. For example, prefer:
<pre>
myProperties.properties
</pre>
        to
<pre>
myproperties.properties
my_properties.properties
</pre>
    </li>
</ul>Z
CODE_SMELL
É
jproperties:end-line-charactersﬂ
jpropertiesend-line-characters(End-line characters should be consistent"MINOR*jproperties:q<p>End-line characters should be consistent in order to prevent polluting SCM history changelog for instance.</p>Z
CODE_SMELL
ø
jproperties:tab-character°
jpropertiestab-character(Tabulation characters should not be used"MINOR*jproperties:∏<p>
    Developers should not need to configure the tab width of their text editors in order to be able to read source code.
    So the use of tabulation character must be banned.
</p>Z
CODE_SMELL
‚
jproperties:no-propertiesƒ
jpropertiesno-properties3Files not defining any properties should be removed"MINOR*jproperties:Q<p>
    Files not defining any properties are useless and should be removed.
</p>Z
CODE_SMELL
à
&jproperties:comment-regular-expression›
jpropertiescomment-regular-expressionRegular expression on comment"MAJOR*jproperties:<p>
    This rule template can be used to create rules which will be triggered when a comment matches a given regular
    expression.
</p>
<p>
    For example, one can create a rule with the regular expression "<code>.*WTF.*</code>" to match all comment
    containing "WTF". Note that, in order to match WTF regardless of the case, the "<code>(?i)</code>" modifier can be
    prepended to the expression, as in "<code>(?i).*WTF.*</code>".
</p>
<p>
    See <a target="_blank" href="http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html">Java
    documentation</a> for detailed regular expression syntax.
</p>@Z
CODE_SMELL
“
jproperties:S2260º
jpropertiesS2260Java Properties parser failure"CRITICAL*jproperties:È<p>
    When the parser fails, it is possible to record the failure as an issue on the file. This way, not only is it
    possible to track the number of files that do not parse but also to easily find out why they do not parse.
</p>ZBUG
ö
jproperties:duplicated-keys˙
jpropertiesduplicated-keys!Duplicated keys should be removed"CRITICAL*jproperties:ö<p>Defining several times the same key leads to unexpected behavior. Thus, you should remove those duplicated keys.</p>

<h2>Noncompliant Code Example</h2>
<pre>
key1=value1
key2=value2
key1=value3
</pre>

<h2>Compliant Solution</h2>
<pre>
key1=value1
key2=value2
key3=value3
</pre>ZBUG
π
 jproperties:missing-translationsî
jpropertiesmissing-translations?Missing translations should be added to locale resource bundles"MAJOR*jproperties:î<p>
    This rule raises an issue each time a translation key is missing in a resource bundle.
</p>

<h2>Noncompliant Code Example</h2>

<i>messages.properties</i>
<pre>
greetings: Hello
farewell: Goodbye
inquiry: How are you?
</pre>

<i>message_fr_FR.properties</i>
<pre>
# Noncompliant: "farewell" property is missing
greetings: Bonjour
inquiry: Comment allez-vous ?
</pre>

<h2>Compliant Solution</h2>

<i>messages.properties</i>
<pre>
greetings: Hello
farewell: Goodbye
inquiry: How are you?
</pre>

<i>message_fr_FR.properties</i>
<pre>
greetings: Bonjour
farewell: Au revoir
inquiry: Comment allez-vous ?
</pre>

<h2>See also</h2>
<ul>
    <li>Related rule <a href='/coding_rules#rule_key=jproperties%3Amissing-translations-in-default'>missing-translations-in-default</a></li>
</ul>ZBUG
„
$jproperties:value-regular-expression∫
jpropertiesvalue-regular-expressionRegular expression on value"MAJOR*jproperties:—<p>
    This rule template can be used to create rules which will be triggered when a value matches a given regular
    expression.
</p>
<p>
    For example, one can create a rule with the regular expression "<code>^blabla.*</code>" to match all values starting
    with 'blabla'.
</p>
<p>
    See <a target="_blank" href="http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html">Java
    documentation</a> for detailed regular expression syntax.
</p>@Z
CODE_SMELL
≈
jproperties:indentation©
jpropertiesindentation4All properties and comments should start at column 1"MINOR*jproperties:∂<p>For readability reasons, all properties and comments should be aligned at column 1.</p>

<h2>Noncompliant Code Example</h2>
<pre>
           key1=value1
      key2=value2

        # comments
        key3=value3
</pre>

<h2>Compliant Solution</h2>
<pre>
key1=value1
key2=value2

# comments
key3=value3
</pre>Z
CODE_SMELL
Í

!jproperties:key-naming-conventionƒ

jpropertieskey-naming-convention&Keys should follow a naming convention"MINOR*jproperties:’	<p>
    Shared coding conventions allow teams to collaborate efficiently. This rule checks that all keys match a provided
    regular expression.
</p>
<p>
    As Java properties files are used in a large variety of ways and by many frameworks, it might sometimes be tricky to
    enforce a strict key naming convention. However, the default regular expression has been designed to match as
    closely as possible the following guidelines:
</p>
<ul>
    <li>Only use letters, digits and '.' characters
<pre>
bank-account-number=123456   # Noncompliant
bank_account_owner=John Doe  # Noncompliant
</pre>
    </li>
    <li>Follow object-oriented programming concept as much as possible. For example, prefer:
<pre>
bank.account.number=123456
bank.account.owner=John Doe
</pre>
        to
<pre>
bankAccountNumber=123456
bankAccountOwner=John Doe
</pre>
    </li>
    <li>Whenever possible, use lowercase characters. For example, prefer:
<pre>
bank.account.number=123456
bank.account.owner=John Doe
</pre>
        to
<pre>
Bank.Account.Number=123456
Bank.Account.Owner=John Doe
</pre>
        But keep it readable. For example, prefer:
<pre>
font.timesNewRoman.size=10
</pre>
        to
<pre>
font.timesnewroman.size=10
</pre>
    </li>
</ul>Z
CODE_SMELL
Ï
jproperties:empty-elementŒ
jpropertiesempty-element+Property with empty value should be removed"CRITICAL*jproperties:ﬂ<p>
    Setting an empty value to a key is often useless. But if it is really intended, a comment should be added to explain
    the purpose of the empty property.
</p>

<h2>Noncompliant Code Example</h2>
<pre>
key1=
</pre>Z
CODE_SMELL
À
jproperties:bom-utf8-files¨
jpropertiesbom-utf8-files8Byte Order Mark (BOM) should not be used for UTF-8 files"MAJOR*jproperties:≤<p>
    As stated in the Unicode specifications, use of a Byte Order Mark (BOM) is neither required nor recommended for
    UTF-8 files.
</p>

<h2>See</h2>
<ul>
    <li><a href="http://www.unicode.org/versions/Unicode8.0.0/ch02.pdf">Unicode Specifications (2.6 Encoding
        Schemes)</a>
    </li>
</ul>Z
CODE_SMELL
Ü
jproperties:maximum-number-keys‚
jpropertiesmaximum-number-keys Number of keys should be reduced"MAJOR*jproperties:˚<p>
    A properties file that grows too much becomes harder to understand and therefore to maintain. Above a specific
    number of keys, it is strongly advised to refactor it into smaller properties files which focus on well defined
    scopes.
</p>Z
CODE_SMELL
§
jproperties:line-lengthà
jpropertiesline-lengthLines should not be too long"MINOR*jproperties:≠<p>Having to scroll horizontally makes it harder to get a quick overview and understanding of any piece of code.</p>

<h2>Noncompliant Code Example</h2>
With maximum length set to 50:
<pre>
myProperty=blabla blabla blabla blabla blabla blabla blabla blabla blabla
</pre>

<h2>Compliant Solution</h2>
With maximum length set to 50:
<pre>
myProperty=blabla blabla blabla blabla blabla\
           blabla blabla blabla blabla
</pre>Z
CODE_SMELL
ú
squid:S00113ã
squidS001131Files should contain an empty new line at the end"MINOR*java2S113:ß<p>Some tools such as Git work better when files end with an empty line.</p>
<p>This rule simply generates an issue if it is missing.</p>
<p>For example, a Git diff looks like this if the empty line is missing at the end of the file:</p>
<pre>
+class Test {
+}
\ No newline at end of file
</pre>Z
CODE_SMELL
ú
squid:S3340å
squidS3340KAnnotation arguments should appear in the order in which they were declared"MINOR*java:ï<p>For optimal code readability, annotation arguments should be specified in the same order that they were declared in the annotation definition.</p>Z
CODE_SMELL
≤
common-java:FailedUnitTestsí
common-javaFailedUnitTests!Failed unit tests should be fixed"MAJOR*java:ºTest failures or errors generally indicate that regressions have been introduced. Those tests should be handled as soon as possible to reduce the cost to fix the corresponding regressions.ZBUG
è
common-java:SkippedUnitTestsÓ
common-javaSkippedUnitTests4Skipped unit tests should be either removed or fixed"MAJOR*java:~Skipped unit tests are considered as dead code. Either they should be activated again (and updated) or they should be removed.Z
CODE_SMELL
Û
common-java:DuplicatedBlocks“
common-javaDuplicatedBlocks2Source files should not have any duplicated blocks"MAJOR*java:dAn issue is created on a file as soon as there is at least one block of duplicated code on this fileZ
CODE_SMELL
ù
&common-java:InsufficientCommentDensityÚ
common-javaInsufficientCommentDensity>Source files should have a sufficient density of comment lines"MAJOR*java:ÌAn issue is created on a file as soon as the density of comment lines on this file is less than the required threshold. The number of comment lines to be written in order to reach the required threshold is provided by each issue message.Z
CODE_SMELL
‚
$common-java:InsufficientLineCoverageπ
common-javaInsufficientLineCoverage3Lines should have sufficient coverage by unit tests"MAJOR*java:¡An issue is created on a file as soon as the line coverage on this file is less than the required threshold. It gives the number of lines to be covered in order to reach the required threshold.Z
CODE_SMELL
Ì
&common-java:InsufficientBranchCoverage¬
common-javaInsufficientBranchCoverage6Branches should have sufficient coverage by unit tests"MAJOR*java:≈An issue is created on a file as soon as the branch coverage on this file is less than the required threshold.It gives the number of branches to be covered in order to reach the required threshold.Z
CODE_SMELL