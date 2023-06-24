describe.only(() => {
  it("tests something", () => {
    console.log("hello world");
  });

  it.only("tests something else", () => {
    console.log("hello world");
  });
});
