pragma solidity ^0.5.0;

contract Decentragram {
  // Code goes here...
  string public name = "Decentragram";

  mapping(uint => Image) public images;
  uint public imageCount = 0;

  struct Image {
    uint id;
    string hash;
    string desc;
    uint tipAmount;
    address payable author;
  }

  event ImageUploaded(
    uint id,
    string hash,
    string desc,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string desc,
    uint tipAmount,
    address payable author
  );

  function uploadImage(string memory _imgHash, string memory _desc) public {
    require(msg.sender != address(0x0), "Error, sender address is missing.");
    require(bytes(_imgHash).length > 0, "Error, hash is missing.");
    require(bytes(_desc).length > 0, "Error, description is missing.");

    imageCount++;
    images[imageCount] = Image(imageCount, _imgHash, _desc, 0, msg.sender);
    emit ImageUploaded(imageCount, _imgHash, _desc, 0, msg.sender);
  }

  function tipImageOwner(uint _id) public payable {
    require(_id > 0 && _id <= imageCount, "Error, not a valid image");
    require(msg.value > 0, "Error, tip amount must not be 0.");

    Image memory _img = images[_id];
    address payable _author = _img.author;

    // _author.transfer(msg.value);
    address(_author).transfer(msg.value);

    _img.tipAmount += msg.value;
    // Need to map it back to update the data
    images[_id] = _img;

    emit ImageTipped(_id, _img.hash, _img.desc, _img.tipAmount, _author);
  }

}